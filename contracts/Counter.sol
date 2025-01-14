// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Counter  {
    uint256 public count;

    function increment() public {
        count++;
    }

}
