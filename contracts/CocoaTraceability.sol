// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CocoaTraceability {
    struct BatchProof {
        string batchId;
        string dataHash;
        string producer;
        string origin;
        string cocoaType;
        string weight;
        address publisher;
        uint256 publishedAt;
        bool exists;
    }

    mapping(string => BatchProof) private proofsByHash;
    mapping(string => string) private hashByBatchId;

    event BatchPublished(
        string indexed batchId,
        string dataHash,
        address indexed publisher,
        uint256 publishedAt
    );

    function publishBatch(
        string calldata batchId,
        string calldata dataHash,
        string calldata producer,
        string calldata origin,
        string calldata cocoaType,
        string calldata weight
    ) external {
        require(bytes(batchId).length > 0, "Batch ID required");
        require(bytes(dataHash).length > 0, "Data hash required");
        require(!proofsByHash[dataHash].exists, "Hash already published");

        proofsByHash[dataHash] = BatchProof({
            batchId: batchId,
            dataHash: dataHash,
            producer: producer,
            origin: origin,
            cocoaType: cocoaType,
            weight: weight,
            publisher: msg.sender,
            publishedAt: block.timestamp,
            exists: true
        });

        hashByBatchId[batchId] = dataHash;

        emit BatchPublished(batchId, dataHash, msg.sender, block.timestamp);
    }

    function getProofByHash(string calldata dataHash) external view returns (BatchProof memory) {
        require(proofsByHash[dataHash].exists, "Proof not found");
        return proofsByHash[dataHash];
    }

    function getProofByBatchId(string calldata batchId) external view returns (BatchProof memory) {
        string memory dataHash = hashByBatchId[batchId];
        require(bytes(dataHash).length > 0, "Batch not found");
        return proofsByHash[dataHash];
    }
}
