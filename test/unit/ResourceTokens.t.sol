// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/game/ResourceTokens.sol";

contract ResourceTokensTest is Test {
    ResourceTokens token;
    address owner = address(this);
    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        token = new ResourceTokens();
    }

    function test_InitialState() public {
        assertEq(token.owner(), owner);
        assertEq(token.WOOD(), 1);
        assertEq(token.STEEL(), 2);
        assertEq(token.CRYSTAL(), 3);
        assertEq(token.SWORD(), 4);
    }

    function test_Mint() public {
        token.mint(alice, token.WOOD(), 100);
        assertEq(token.balanceOf(alice, token.WOOD()), 100);
    }

    function test_Mint_RevertNotOwner() public {
        uint256 wood = token.WOOD();
        vm.prank(alice);
        vm.expectRevert();
        token.mint(bob, wood, 100);
    }

    function test_Burn() public {
        token.mint(alice, token.WOOD(), 100);
        
        token.burn(alice, token.WOOD(), 40);
        assertEq(token.balanceOf(alice, token.WOOD()), 60);
    }

    function test_Burn_RevertNotOwner() public {
        uint256 wood = token.WOOD();
        token.mint(alice, wood, 100);

        vm.prank(alice);
        vm.expectRevert();
        token.burn(alice, wood, 40);
    }

    function test_Burn_RevertInsufficientBalance() public {
        uint256 wood = token.WOOD();
        token.mint(alice, wood, 10);
        vm.expectRevert();
        token.burn(alice, wood, 40);
    }
}
