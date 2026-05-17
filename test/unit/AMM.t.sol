// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../contracts/game/AMM.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Mock1155 is ERC1155("") {
    function mint(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}

contract AMMTest is Test {
    Mock1155 token;
    AMM amm;

    address alice = address(1);

    function setUp() public {
        token = new Mock1155();
        amm = new AMM(token);

        token.mint(address(this), 1, 1_000 ether);
        token.mint(address(this), 2, 1_000 ether);

        token.mint(alice, 1, 1_000 ether);

        token.setApprovalForAll(address(amm), true);

        vm.prank(alice);
        token.setApprovalForAll(address(amm), true);

        amm.addLiquidity(1, 500 ether);
        amm.addLiquidity(2, 500 ether);
    }

    function testSwap() public {
        vm.startPrank(alice);

        uint256 beforeBal = token.balanceOf(alice, 2);

        amm.swap(
            1,
            2,
            100 ether,
            1
        );

        uint256 afterBal = token.balanceOf(alice, 2);

        assertGt(afterBal, beforeBal);

        vm.stopPrank();
    }
}