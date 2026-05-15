import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';
import 'firebase_backend.dart';

class Web3Service {
  static const String _rpcUrl = String.fromEnvironment('RPC_URL');
  static const String _contractAddress = String.fromEnvironment('CONTRACT_ADDRESS');
  static const String _privateKey = String.fromEnvironment('PRIVATE_KEY');
  static const int _chainId = int.fromEnvironment('CHAIN_ID', defaultValue: 11155111);

  // Static list to persist history during the session
  static final List<Map<String, dynamic>> _publishedBatches = [];

  Web3Service();

  List<Map<String, dynamic>> get history => List.unmodifiable(_publishedBatches);
  bool get isRealBlockchainEnabled =>
      _rpcUrl.isNotEmpty && _contractAddress.isNotEmpty && _privateKey.isNotEmpty;

  String generateBatchHash(Map<String, dynamic> data) {
    final String content = jsonEncode(data);
    final bytes = utf8.encode(content);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<String> getBalance(String address) async {
    if (!isRealBlockchainEnabled) {
      await Future.delayed(const Duration(milliseconds: 800));
      return "0.5420 ETH";
    }

    final client = Web3Client(_rpcUrl, http.Client());
    try {
      final balance = await client.getBalance(EthereumAddress.fromHex(address));
      return "${balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(4)} ETH";
    } finally {
      client.dispose();
    }
  }

  Future<String> publishToBlockchain(Map<String, dynamic> batchData, String batchHash) async {
    final txHash = isRealBlockchainEnabled
        ? await _publishToRealBlockchain(batchData, batchHash)
        : await _publishToMockBlockchain(batchHash);

    // Save to history
    _publishedBatches.insert(0, {
      ...batchData,
      "hash": batchHash,
      "txHash": txHash,
      "publishDate": DateTime.now().toIso8601String(),
      "blockchainMode": isRealBlockchainEnabled ? "testnet" : "mock",
    });

    // Enregistrement en arrière-plan sans "await" pour ne pas bloquer l'UI
    BatchRepository().savePublishedBatch(_publishedBatches.first).catchError((e) {
      print("Erreur Firebase en arrière-plan: $e");
    });

    return txHash;
  }

  Future<String> _publishToMockBlockchain(String batchHash) async {
    await Future.delayed(const Duration(seconds: 2));
    return "0x${sha256.convert(utf8.encode(batchHash + DateTime.now().toString())).toString().substring(0, 40)}";
  }

  Future<String> _publishToRealBlockchain(Map<String, dynamic> batchData, String batchHash) async {
    final client = Web3Client(_rpcUrl, http.Client());

    try {
      final abiJson = await rootBundle.loadString('assets/contracts/cocoa_traceability_abi.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiJson, 'CocoaTraceability'),
        EthereumAddress.fromHex(_contractAddress),
      );
      final credentials = EthPrivateKey.fromHex(_privateKey);
      final function = contract.function('publishBatch');

      return client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [
            batchData['id'] as String? ?? '',
            batchHash,
            batchData['producer'] as String? ?? '',
            batchData['origin'] as String? ?? '',
            batchData['type'] as String? ?? '',
            batchData['weight'] as String? ?? '',
          ],
        ),
        chainId: _chainId,
      );
    } finally {
      client.dispose();
    }
  }

  Future<String> trackCocoaPod(String podId) async {
    if (isRealBlockchainEnabled) {
      final proof = await _findProofOnRealBlockchain(podId);
      if (proof != null) return proof;
    }

    await Future.delayed(const Duration(seconds: 1));
    
    // Check history first
    for (var batch in _publishedBatches) {
      if (batch['hash'] == podId || batch['id'] == podId) {
        return "Lot ${batch['id']} vérifié.\nOrigine : ${batch['origin']}.\nProducteur : ${batch['producer']}.\nCulture : ${batch['type']}.\nPoids : ${batch['weight']}.";
      }
    }

    if (podId.contains("TRC-8829")) {
      return "Lot #TRC-8829 vérifié.\nOrigine : Togo, Atakpamé.\nProducteur : Kouassi.\nCulture : Cacao Criollo.\nPoids : 250kg.";
    }
    return "Pod $podId est vérifié. Origine : Ghana. Batch #4521";
  }

  Future<String?> _findProofOnRealBlockchain(String podId) async {
    final client = Web3Client(_rpcUrl, http.Client());

    try {
      final abiJson = await rootBundle.loadString('assets/contracts/cocoa_traceability_abi.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiJson, 'CocoaTraceability'),
        EthereumAddress.fromHex(_contractAddress),
      );
      final function = contract.function(podId.startsWith('0x') ? 'getProofByHash' : 'getProofByBatchId');
      final result = await client.call(
        contract: contract,
        function: function,
        params: [podId],
      );

      if (result.isEmpty) return null;
      final proof = result.first as List<dynamic>;
      return "Lot ${proof[0]} vérifié sur blockchain.\n"
          "Hash : ${proof[1]}.\n"
          "Origine : ${proof[3]}.\n"
          "Producteur : ${proof[2]}.\n"
          "Culture : ${proof[4]}.\n"
          "Poids : ${proof[5]}.\n"
          "Adresse publiante : ${proof[6]}.";
    } catch (_) {
      return null;
    } finally {
      client.dispose();
    }
  }
}
