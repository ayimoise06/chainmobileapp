import 'dart:convert';
import 'package:crypto/crypto.dart';

class Web3Service {
  // Static list to persist history during the session
  static final List<Map<String, dynamic>> _publishedBatches = [];

  Web3Service();

  List<Map<String, dynamic>> get history => List.unmodifiable(_publishedBatches);

  String generateBatchHash(Map<String, dynamic> data) {
    final String content = jsonEncode(data);
    final bytes = utf8.encode(content);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<String> getBalance(String address) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return "0.5420 ETH";
  }

  Future<String> publishToBlockchain(Map<String, dynamic> batchData, String batchHash) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final txHash = "0x${sha256.convert(utf8.encode(batchHash + DateTime.now().toString())).toString().substring(0, 40)}";
    
    // Save to history
    _publishedBatches.insert(0, {
      ...batchData,
      "hash": batchHash,
      "txHash": txHash,
      "publishDate": DateTime.now().toIso8601String(),
    });

    return txHash;
  }

  Future<String> trackCocoaPod(String podId) async {
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
}
