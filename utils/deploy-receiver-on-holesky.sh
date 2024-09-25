#!/bin/bash

HOLESKY_RPC_URL=$(grep HOLESKY_RPC_URL .env | cut -d '=' -f2)
HOLESKY_PRIVATE_KEY=$(grep HOLESKY_PRIVATE_KEY .env | cut -d '=' -f2)
HOLESKY_ENDPOINT_V2=$(grep HOLESKY_ENDPOINT_V2 .env | cut -d '=' -f2)

output1=$(forge create contracts/src/EthereumLzApp.sol:EthereumLzApp --rpc-url $HOLESKY_RPC_URL --private-key $HOLESKY_PRIVATE_KEY --constructor-args $HOLESKY_ENDPOINT_V2 --verify --etherscan-api-key $ETHERSCAN_API_KEY)

CONTRACT_ADDRESS=$(echo "$output1" | grep "Deployed to:" | awk '{print $NF}')
echo "EthereumLzApp contract deployed at: $CONTRACT_ADDRESS"

forge inspect contracts/src/EthereumLzApp.sol:EthereumLzApp abi > utils/abi/EthereumLzApp.json
echo "EthereumLzApp ABI saved to utils/abi/EthereumLzApp.json"
