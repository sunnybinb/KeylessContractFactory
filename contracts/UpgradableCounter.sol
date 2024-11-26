// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract UpgradableCounter is UUPSUpgradeable {
    uint256 public count;
    address public owner;

    function initialize() public initializer {
        count = 1;
    }

    function initializeWithArg(uint256 _count, address _owner) public initializer {
        count = _count;
        owner = _owner;
    }

    function increment() public {
        count++;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
    }
}
