// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "contracts/game/AMM.sol";
import "contracts/game/ResourceTokens.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract AMMTest is Test, ERC1155Holder {
    AMM public amm;
    ResourceTokens public token;

    function setUp() public {
        token = new ResourceTokens();
        amm = new AMM(token);

        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);
        token.setApprovalForAll(address(amm), true);

        amm.addLiquidity(1, 500_000 ether);
        amm.addLiquidity(2, 500_000 ether);
    }

    function testSwapWorks() public {
        uint256 amountOut = amm.getAmountOut(1, 2, 100 ether);
        uint256 balanceBefore = token.balanceOf(address(this), 2);

        amm.swap(1, 2, 100 ether, 1);

        uint256 balanceAfter = token.balanceOf(address(this), 2);
        assertEq(balanceAfter - balanceBefore, amountOut);
    }
}