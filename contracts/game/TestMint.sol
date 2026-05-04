// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockGameItems {

    event MintCalled(address to, uint256 id);

    function mint(address to, uint256 id, uint256, bytes calldata) external {
        emit MintCalled(to, id);
    }
}