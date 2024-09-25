# TriggerX Contracts

Contracts for TriggerX

## Steps to follow:

1. Install dependencies:
   ```
   make install
   ```

2. Set environment:
   ```
   source .env
   ```

3. Build contracts:
   ```
   make build-contracts
   ```

4. Deploy contracts:
   - On Holesky network:
     ```
     make deploy-contracts-on-holesky
     ```
   - On Shasta network:
     ```
     make deploy-contracts-on-shasta
     ```

5. Send a message:
   
   Add the deployed contract address in sendMessage.js file.
   ```
   make send-message
   ```

Note: You can use `make help` to see a list of available commands and their descriptions.

