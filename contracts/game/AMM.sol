// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

//Muzaffar
contract AMM {
    IERC1155 public resourceToken;
    uint256 public k; // constant product

    constructor(IERC1155 _resourceToken, uint256 _k) {
        resourceToken = _resourceToken;
        k = _k;
    }

    function swap(uint256 fromId, uint256 toId, uint256 amount) external {
        uint256 fromBalance = resourceToken.balanceOf(msg.sender, fromId);
        uint256 toBalance = resourceToken.balanceOf(address(this), toId);

        require(fromBalance >= amount, "Insufficient balance");

        uint256 newToBalance = toBalance - (k / (fromBalance - amount));
        require(newToBalance <= toBalance, "Slippage exceeded");

        resourceToken.safeTransferFrom(msg.sender, address(this), fromId, amount, "");
        resourceToken.safeTransferFrom(address(this), msg.sender, toId, newToBalance, "");
    }
}
// .