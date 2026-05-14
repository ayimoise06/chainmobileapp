# Blockchain testnet setup

This app can publish cocoa batch proofs to a real EVM blockchain testnet.

The app keeps Firebase as the database and stores only a proof hash on-chain.
If the blockchain values below are not provided, the app keeps using the local mock mode.

## 1. Deploy the contract

Use Remix for the first deployment:

1. Open https://remix.ethereum.org
2. Create `CocoaTraceability.sol`
3. Copy the contract from `contracts/CocoaTraceability.sol`
4. Compile with Solidity `0.8.20` or newer
5. Deploy to a testnet with MetaMask, for example Sepolia or Polygon Amoy
6. Copy the deployed contract address

You need testnet tokens from a faucet. These have no real-money value.

## 2. Get an RPC URL

Use a testnet RPC URL from a provider such as Alchemy, Infura, QuickNode, or a public RPC.

Examples of chain IDs:

- Sepolia: `11155111`
- Polygon Amoy: `80002`

## 3. Run the app with blockchain enabled

For local testing only:

```bash
flutter run -d chrome \
  --dart-define=RPC_URL="https://your-testnet-rpc-url" \
  --dart-define=CONTRACT_ADDRESS="0xYourContractAddress" \
  --dart-define=PRIVATE_KEY="your_test_wallet_private_key" \
  --dart-define=CHAIN_ID=11155111
```

Never put a real wallet private key in the app.
Use a dedicated test wallet with testnet funds only.

## 4. Production note

For production, do not sign transactions directly inside the mobile/web app.
Use WalletConnect or a backend signer with strict authorization rules.
