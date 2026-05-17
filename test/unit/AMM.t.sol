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

    function testAddLiquidityRevertZeroAmount() public {
        vm.expectRevert(AMM.InvalidAmount.selector);
        amm.addLiquidity(1, 0);
    }

    function testRemoveLiquidity() public {
        uint256 balanceBefore = token.balanceOf(address(this), 1);
        
        vm.expectEmit(true, true, false, true);
        emit AMM.LiquidityRemoved(address(this), 1, 100 ether);
        amm.removeLiquidity(1, 100 ether);

        uint256 balanceAfter = token.balanceOf(address(this), 1);
        assertEq(balanceAfter - balanceBefore, 100 ether);
        assertEq(amm.reserves(1), 499_900 ether);
    }

    function testRemoveLiquidityRevertZeroAmount() public {
        vm.expectRevert(AMM.InvalidAmount.selector);
        amm.removeLiquidity(1, 0);
    }

    function testRemoveLiquidityRevertInsufficient() public {
        vm.expectRevert(AMM.InsufficientLiquidity.selector);
        amm.removeLiquidity(1, 600_000 ether);
    }

    function testSwapRevertZeroAmount() public {
        vm.expectRevert(AMM.InvalidAmount.selector);
        amm.swap(1, 2, 0, 1);
    }

    function testSwapRevertSlippage() public {
        uint256 amountOut = amm.getAmountOut(1, 2, 100 ether);
        vm.expectRevert(AMM.SlippageExceeded.selector);
        amm.swap(1, 2, 100 ether, amountOut + 1);
    }

    function testSwapRevertInsufficientLiquidityZeroReserve() public {
        vm.expectRevert(AMM.InsufficientLiquidity.selector);
        amm.swap(3, 1, 100 ether, 1); // Token 3 has 0 reserve
    }

    function testGetAmountOutZeroReserves() public {
        uint256 out = amm.getAmountOut(3, 1, 100 ether);
        assertEq(out, 0);
    }
}