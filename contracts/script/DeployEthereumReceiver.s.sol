// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "forge-std/Script.sol";
import "../src/EthereumLayerZeroReceiver.sol";

contract DeployEthereumReceiver is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // LayerZero Endpoint address for Ethereum Sepolia testnet
        address lzEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
        
        // Source chain ID (e.g., Tron Nile testnet)
        uint16 srcChainId = 109; 
        
        // Replace with your Tron sender contract address (hex encoded)
        bytes memory srcAddr = hex"c72F42f429212D07f59aefDb8d4fE975713320a8"; 

        EthereumLayerZeroReceiver receiver = new EthereumLayerZeroReceiver(
            lzEndpoint,
            srcChainId,
            srcAddr
        );

        console.log("EthereumLayerZeroReceiver deployed to:", address(receiver));

        // Set trusted remote (optional, but recommended for security)
        receiver.setTrustedRemote(srcChainId, srcAddr);

        vm.stopBroadcast();
    }
}