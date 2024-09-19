// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./interfaces/ILayerZeroReceiver.sol";
import "./interfaces/ILayerZeroEndpoint.sol";

contract EthereumLayerZeroReceiver is Ownable, Pausable, ILayerZeroReceiver {
    ILayerZeroEndpoint public lzEndpoint;
    uint16 public srcChainId;
    bytes public srcAddr;

    event MessageReceived(uint16 srcChainId, address srcAddress, string message);
    event MessageSent(address indexed sender, string message);

    constructor(address _lzEndpoint, uint16 _srcChainId, bytes memory _srcAddr) {
        lzEndpoint = ILayerZeroEndpoint(_lzEndpoint);
        srcChainId = _srcChainId;
        srcAddr = _srcAddr;
    }

    function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
        require(msg.sender == address(lzEndpoint), "Invalid endpoint caller");
        require(_srcChainId == srcChainId, "Invalid source chain ID");
        require(keccak256(_srcAddress) == keccak256(srcAddr), "Invalid source address");

        string memory message = abi.decode(_payload, (string));
        emit MessageReceived(_srcChainId, _srcAddress.toAddress(), message);
    }

    function sendMessage(string calldata _message) external payable whenNotPaused {
        bytes memory payload = abi.encode(_message);
        uint16 version = 1;
        uint256 gasForDestinationLzReceive = 350000;
        bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);

        (uint256 messageFee, ) = lzEndpoint.estimateFees(srcChainId, address(this), payload, false, adapterParams);
        require(msg.value >= messageFee, "Not enough value for fees");

        lzEndpoint.send{value: msg.value}(
            srcChainId,
            srcAddr,
            payload,
            payable(msg.sender),
            address(0x0),
            adapterParams
        );

        emit MessageSent(msg.sender, _message);
    }

    function setSrcChainConfig(uint16 _srcChainId, bytes memory _srcAddr) external onlyOwner {
        srcChainId = _srcChainId;
        srcAddr = _srcAddr;
    }

    function setLzEndpoint(address _lzEndpoint) external onlyOwner {
        lzEndpoint = ILayerZeroEndpoint(_lzEndpoint);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}