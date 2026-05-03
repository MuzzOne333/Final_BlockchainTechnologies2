// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Muzaffar
contract StakingVault is Ownable {
    IERC20 public stakingToken;
    uint256 public totalDeposits;
    mapping(address => uint256) public userDeposits;

    constructor(IERC20 _stakingToken) {
        stakingToken = _stakingToken;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        stakingToken.transferFrom(msg.sender, address(this), amount);
        totalDeposits += amount;
        userDeposits[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(userDeposits[msg.sender] >= amount, "Insufficient balance");
        stakingToken.transfer(msg.sender, amount);
        totalDeposits -= amount;
        userDeposits[msg.sender] -= amount;
    }

    function calculateReward(address user) public view returns (uint256) {
        return (userDeposits[user] * 10) / 100; // Example: 10% reward
    }
}

// .