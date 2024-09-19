const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const EthereumLayerZeroReceiver = await ethers.getContractFactory("EthereumLayerZeroReceiver");
  const lzEndpoint = '0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1';  // LayerZero Endpoint address for Ethereum Sepolia testnet
  const srcChainId = 1000;  // Source chain ID (Tron Nile testnet)
  const srcAddr = '0x...';  // Replace with your Tron sender contract address (hex encoded)

  const receiver = await EthereumLayerZeroReceiver.deploy(lzEndpoint, srcChainId, srcAddr);

  await receiver.deployed();

  console.log("EthereumLayerZeroReceiver deployed to:", receiver.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });