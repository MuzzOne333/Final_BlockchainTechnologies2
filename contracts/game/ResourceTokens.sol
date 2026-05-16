// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Muzaffar
contract ResourceTokens is ERC1155, Ownable {
    uint256 public constant WOOD = 1;
    uint256 public constant STEEL = 2;
    uint256 public constant CRYSTAL = 3;
    uint256 public constant SWORD = 4;

    constructor()
    ERC1155("https://api.game.com/api/token/{id}.json")
    Ownable(msg.sender)
    {}

    function mint(address account, uint256 id, uint256 amount) external onlyOwner {
        _mint(account, id, amount, "");
    }

    function burn(address account, uint256 id, uint256 amount) external onlyOwner {
        _burn(account, id, amount);
    }
}