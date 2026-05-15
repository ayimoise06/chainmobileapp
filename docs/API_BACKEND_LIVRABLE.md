# Configuration du Backend d'Administration (Livrable Concours)

Pour protéger le projet en production, la publication sur la blockchain n'est plus faite depuis l'application mobile de l'utilisateur (faille de sécurité). Elle passe par un serveur externe via les **Firebase Cloud Functions**.

**Ce que doit faire le jury / l'administrateur final :**
Dans leur panel Firebase, ils doivent héberger cette fonction qui possèdera les clés sécurisées :

```javascript
// A déposer dans Firebase Functions (index.js)
const functions = require("firebase-functions");
const { ethers } = require("ethers");

exports.publishBatchToBlockchain = functions.https.onCall(async (data, context) => {
    // Vérification de sécurité: l'utilisateur est-il connecté et admin ?
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "Vous devez être connecté.");
    }

    const { batchId, batchHash, producer, origin, type, weight } = data;

    // Récupération des clés privées depuis les variables secrètes du serveur
    const RPC_URL = process.env.RPC_URL;
    const PRIVATE_KEY = process.env.PRIVATE_KEY;
    const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

    try {
        const provider = new ethers.providers.JsonRpcProvider(RPC_URL);
        const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
        
        // Insérer ici l'ABI
        const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, wallet);

        // Publication sur Sepolia
        const tx = await contract.publishBatch(batchId, batchHash, producer, origin, type, weight);
        await tx.wait();

        return { txHash: tx.hash };

    } catch (e) {
        console.error(e);
        throw new functions.https.HttpsError("internal", "Erreur transaction blockchain.");
    }
});
```

**Pourquoi avoir fait cela ?**
1. L'application Flutter (le Frontend) n'a plus JAMAIS accès à `PRIVATE_KEY`.
2. S'il y a un problème sur la blockchain, seul le serveur s'en aperçoit.
3. Seul l'administrateur central contrôle le portefeuille accrédité qui signe la fraude des lots.
