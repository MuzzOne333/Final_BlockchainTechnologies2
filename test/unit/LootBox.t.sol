// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "contracts/game/LootBox.sol";

contract MockGameItems is IGameItems {
    mapping(address => mapping(uint256 => uint256)) public balances;

    function mint(address account, uint256 id, uint256 amount) external override {
        balances[account][id] += amount;
    }
}

contract LootBoxTest is Test {
    LootBox lootBox;
    MockGameItems gameItems;
    address user = address(0x1);

    function setUp() public {
        gameItems = new MockGameItems();
        lootBox = new LootBox(address(gameItems), 0.01 ether);
    }

    function test_OpenLootBox() public {
        vm.deal(user, 1 ether);
        
        vm.prank(user);
        vm.expectEmit(false, false, false, false);
        emit LootBox.LootBoxOpened(user, 1); // Exact item ID is pseudo-random
        lootBox.openLootBox{value: 0.01 ether}();

        // One of the items 1, 2, 3, or 4 should be minted
        uint256 balance = gameItems.balances(user, 1) + 
                          gameItems.balances(user, 2) + 
                          gameItems.balances(user, 3) + 
                          gameItems.balances(user, 4);
        assertEq(balance, 1);
    }

    function test_OpenLootBox_RevertNotEnoughPayment() public {
        vm.deal(user, 1 ether);
        
        vm.prank(user);
        vm.expectRevert("Not enough payment");
        lootBox.openLootBox{value: 0.009 ether}();
    }
}
