// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {CREATE3} from "solady/src/utils/CREATE3.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// @title Factory for deploying contracts to deterministic addresses via CREATE3
/// @author zefram.eth, SKYBIT
/// @notice Enables deploying contracts using CREATE3. Each deployer (msg.sender) has
/// its own namespace for deployed addresses.
contract ContractFactory {
    //Create3
    function deploy(bytes32 salt, bytes memory creationCode) external payable returns (address) {
        // hash salt with the deployer address to give each deployer its own namespace
        salt = keccak256(abi.encodePacked(msg.sender, salt));
        return CREATE3.deployDeterministic(creationCode, salt);
    }

    function deployByCreate2(bytes32 salt, bytes memory creationCode) external returns (address) {
        salt = keccak256(abi.encodePacked(msg.sender, salt));

        address deployedContract;

        assembly {
            deployedContract := create2(0, add(creationCode, 0x20), mload(creationCode), salt)
            if iszero(deployedContract) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
        return deployedContract;
    }

    function getCreate3Deployed(bytes32 salt) external view returns (address) {
        // hash salt with the deployer address to give each deployer its own namespace
        salt = keccak256(abi.encodePacked(msg.sender, salt));
        return CREATE3.predictDeterministicAddress(salt);
    }

    function getCreate2Deployed(bytes32 salt, bytes calldata bytecode)
        external
        view
        returns (address deploymentAddress)
    {
        // determine the address where the contract will be deployed.
        deploymentAddress = address(
            uint160( // downcast to match the address type.
                uint256( // convert to uint to truncate upper digits.
                    keccak256( // compute the CREATE2 hash using 4 inputs.
                        abi.encodePacked( // pack all inputs to the hash together.
                            hex"ff", // start with 0xff to distinguish from RLP.
                            address(this), // this contract will be the caller.
                            salt, // pass in the supplied salt value.
                            keccak256(abi.encodePacked(bytecode)) // pass in the hash of initialization code.
                        )
                    )
                )
            )
        );
    }
}
