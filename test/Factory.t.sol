// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "forge-std/Test.sol";
import {ContractFactory} from "../contracts/ContractFactory.sol";
import {Counter} from "../contracts/Counter.sol";
import {UpgradableCounter} from "../contracts/UpgradableCounter.sol";

contract Create3FactoryTest is Test {
    ContractFactory factory;
    Counter counter;
    UpgradableCounter upgradableCounter;
    address public owner = address(0x123);

    bytes32 salt = keccak256(abi.encodePacked("test_salt"));

    function setUp() public {
        factory = new ContractFactory();
    }

    function testDeployProxytContractWithoutArg() public {
        address upgradableCounterImpl = address(new UpgradableCounter());
        bytes memory bytecode = abi.encodePacked(
            type(ERC1967Proxy).creationCode,
            abi.encode(upgradableCounterImpl, abi.encodeWithSelector(UpgradableCounter.initialize.selector))
        );

        address deployedAddress = factory.deployByCreate2(salt, bytecode);
        upgradableCounter = UpgradableCounter(deployedAddress);
      
        assertEq(upgradableCounter.count(), 1);
    }

    function testDeployProxytContractWithArg() public {
        uint256 num = 10;
        address upgradableCounterImpl = address(new UpgradableCounter());
        bytes memory bytecode = abi.encodePacked(
            type(ERC1967Proxy).creationCode,
            abi.encode(
                upgradableCounterImpl, abi.encodeWithSelector(UpgradableCounter.initializeWithArg.selector, num, owner)
            )
        );

        address deployedAddress = factory.deployByCreate2(salt, bytecode);
        upgradableCounter = UpgradableCounter(deployedAddress);
    
        assertEq(upgradableCounter.count(), 10);
        assertEq(upgradableCounter.owner(), owner);
    }

    function testDeployContract() public {
        bytes memory bytecode = type(Counter).creationCode;
        address deployedAddress = factory.deploy(salt, bytecode);
        counter = Counter(deployedAddress);
        assertEq(counter.count(), 0);
    }
}
