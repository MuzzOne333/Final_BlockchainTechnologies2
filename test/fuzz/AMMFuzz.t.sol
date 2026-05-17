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

contract AMMFuzzTest is Test {
    Mock1155 token;
    AMM amm;

    function setUp() public {
        token = new Mock1155();
        amm = new AMM(token);

        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);

        token.setApprovalForAll(address(amm), true);

        amm.addLiquidity(1, 500_000 ether);
        amm.addLiquidity(2, 500_000 ether);
    }

    function testFuzzSwap(uint96 amountIn) public {
        amountIn = uint96(bound(amountIn, 1 ether, 1000 ether));

        uint256 reserveBefore =
            amm.reserves(1) * amm.reserves(2);

        amm.swap(1, 2, amountIn, 1);

        uint256 reserveAfter =
            amm.reserves(1) * amm.reserves(2);

        assertGe(reserveAfter, reserveBefore);
    }
}