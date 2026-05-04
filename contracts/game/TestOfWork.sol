// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./LootBox.sol";
import "./TestMint.sol";

contract LootBoxTest is Test {

    LootBox lootbox;
    MockGameItems mockItems;

    function setUp() public {
        mockItems = new MockGameItems();
        lootbox = new LootBox(address(mockItems), 0.01 ether);
    }

    function testOpenLootBox() public {
        vm.deal(address(this), 1 ether);

        lootbox.openLootBox{value: 0.01 ether}();
    }
}