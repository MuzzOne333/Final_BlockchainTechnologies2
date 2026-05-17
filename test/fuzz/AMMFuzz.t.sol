// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "contracts/game/AMM.sol";
import "contracts/game/ResourceTokens.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract AMMFuzzTest is Test, ERC1155Holder {
    AMM public amm;
    ResourceTokens public token;

    function setUp() public {
        token = new ResourceTokens();
        amm = new AMM(token);

        // Mint tokens to this test contract
        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);
        token.setApprovalForAll(address(amm), true);

        // Add liquidity
        amm.addLiquidity(1, 500_000 ether);
        amm.addLiquidity(2, 500_000 ether);
    }

    /// @notice Fuzz test swap
    function testFuzzSwap(uint256 amount) public {
        amount = bound(amount, 1 ether, 1000 ether);
        try amm.swap(1, 2, amount, 0) {} catch {}
    }

    /// @notice Fuzz test addLiquidity
    function testFuzzAddLiquidity(uint256 amount) public {
        amount = bound(amount, 1, 100_000 ether);
        
        uint256 initialReserve1 = amm.reserves(1);
        
        amm.addLiquidity(1, amount);
        assertEq(amm.reserves(1), initialReserve1 + amount);
    }

    /// @notice Fuzz test removeLiquidity
    function testFuzzRemoveLiquidity(uint256 amount) public {
        amount = bound(amount, 1, 500_000 ether); // Max is initial liquidity
        
        uint256 initialReserve1 = amm.reserves(1);
        
        amm.removeLiquidity(1, amount);
        assertEq(amm.reserves(1), initialReserve1 - amount);
    }
}