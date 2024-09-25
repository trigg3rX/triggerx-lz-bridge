// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin-upgrades/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin-upgrades/contracts/access/OwnableUpgradeable.sol";
import "@eigenlayer/contracts/permissions/Pausable.sol";

import "@layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";

import "./ItxTaskManager.sol";
import {IRegistryCoordinator} from "@eigenlayer-middleware/src/interfaces/IRegistryCoordinator.sol";

contract txTaskManager is Initializable,
    OwnableUpgradeable,
    Pausable,
    ItxTaskManager,
    NonblockingLzApp
{
    // STATE VARIABLES
    uint32 public immutable TASK_RESPONSE_WINDOW_BLOCK;
    uint32 public constant TASK_CHALLENGE_WINDOW_BLOCK = 100;
    uint256 internal constant _THRESHOLD_DENOMINATOR = 100;

    uint16 public constant SHASTA_CHAIN_ID = 1000;

    IRegistryCoordinator public registryCoordinator;
    address public aggregator;

    mapping(uint32 => Task) public tasks;
    uint32 public taskCount;


    constructor(IRegistryCoordinator _registryCoordinator, uint32 _taskResponseWindowBlock, address _lzEndpoint) 
        NonblockingLzApp(_lzEndpoint)
    {
        registryCoordinator = _registryCoordinator;
        TASK_RESPONSE_WINDOW_BLOCK = _taskResponseWindowBlock;
    }

    function initialize(
        IPauserRegistry _pauserRegistry,
        address initialOwner,
        address _aggregator
    ) public initializer {
        _initializePauser(_pauserRegistry, UNPAUSE_ALL);
        _transferOwnership(initialOwner);
        aggregator = _aggregator;
    }

    function createTask(
        string calldata taskType,
        string calldata status
    ) external {
        taskCount++;
        tasks[taskCount] = Task({
            taskId: taskCount,
            taskType: taskType,
            status: status,
            blockNumber: block.number
        });

        emit TaskCreated(taskCount, taskType);
    }

    function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal override {
    require(_srcChainId == TRON_CHAIN_ID, "Invalid source chain");
    
    (string memory taskType, string memory status) = abi.decode(_payload, (string, string));
    createTask(taskType, status);
    }
}