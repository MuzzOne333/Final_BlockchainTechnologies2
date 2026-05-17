// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "contracts/game/NFTRentalVault.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC1155 is ERC1155 {
    constructor() ERC1155("") {}
    function mint(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock", "MCK") {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract NFTRentalVaultTest is Test {
    NFTRentalVault vault;
    MockERC1155 resourceToken;
    MockERC20 gameToken;

    address lender = address(0x1);
    address renter = address(0x2);

    function setUp() public {
        resourceToken = new MockERC1155();
        gameToken = new MockERC20();
        vault = new NFTRentalVault(address(resourceToken), address(gameToken));

        resourceToken.mint(lender, 1, 10);
        gameToken.mint(renter, 1000 ether);

        vm.prank(lender);
        resourceToken.setApprovalForAll(address(vault), true);

        vm.prank(renter);
        gameToken.approve(address(vault), type(uint256).max);
    }

    function test_ListItem() public {
        vm.prank(lender);
        vm.expectEmit(true, true, false, true);
        emit NFTRentalVault.ItemListed(0, lender, 1, 5, 10 ether);
        vault.listItem(1, 5, 10 ether);

        (address ldr, uint256 tid, uint256 amt, uint256 ppb, address rnt, uint256 rend, uint256 claimable) = vault.listings(0);
        assertEq(ldr, lender);
        assertEq(tid, 1);
        assertEq(amt, 5);
        assertEq(ppb, 10 ether);
        assertEq(rnt, address(0));
        assertEq(rend, 0);
        assertEq(claimable, 0);
        
        assertEq(resourceToken.balanceOf(address(vault), 1), 5);
        assertEq(resourceToken.balanceOf(lender, 1), 5);
    }

    function test_ListItem_RevertZeroAmount() public {
        vm.prank(lender);
        vm.expectRevert("Zero amount");
        vault.listItem(1, 0, 10 ether);
    }

    function test_ListItem_RevertZeroPrice() public {
        vm.prank(lender);
        vm.expectRevert("Zero price");
        vault.listItem(1, 5, 0);
    }

    function test_RentItem() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        uint256 startBlock = block.number;

        vm.prank(renter);
        vm.expectEmit(true, true, false, true);
        emit NFTRentalVault.ItemRented(0, renter, 10);
        vault.rentItem(0, 10);

        (, , , , address rnt, uint256 rend, uint256 claimable) = vault.listings(0);
        assertEq(rnt, renter);
        assertEq(rend, startBlock + 10);
        assertEq(claimable, 100 ether);

        assertEq(gameToken.balanceOf(address(vault)), 100 ether);
        assertEq(gameToken.balanceOf(renter), 900 ether);
    }

    function test_RentItem_RevertNotAvailable() public {
        vm.prank(renter);
        vm.expectRevert("Listing not available");
        vault.rentItem(0, 10);
    }

    function test_RentItem_RevertAlreadyRented() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vault.rentItem(0, 10);

        vm.prank(renter);
        vm.expectRevert("Already rented");
        vault.rentItem(0, 5);
    }

    function test_RentItem_RevertZeroBlocks() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vm.expectRevert("Zero blocks");
        vault.rentItem(0, 0);
    }

    function test_ClaimBack() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vault.rentItem(0, 10);

        vm.roll(block.number + 11);

        vm.prank(lender);
        vm.expectEmit(true, true, false, false);
        emit NFTRentalVault.ItemClaimedBack(0, lender);
        vault.claimBack(0);

        assertEq(resourceToken.balanceOf(lender, 1), 10);
        
        (, , uint256 amt, , , , ) = vault.listings(0);
        assertEq(amt, 0); // Marked as closed
    }

    function test_ClaimBack_RevertNotLender() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vm.expectRevert("Not lender");
        vault.claimBack(0);
    }

    function test_ClaimBack_RevertRentalActive() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vault.rentItem(0, 10);

        vm.roll(block.number + 5); // Rental still active

        vm.prank(lender);
        vm.expectRevert("Rental active");
        vault.claimBack(0);
    }

    function test_ClaimRent() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vault.rentItem(0, 10);

        vm.prank(lender);
        vm.expectEmit(true, true, false, true);
        emit NFTRentalVault.RentClaimed(0, lender, 100 ether);
        vault.claimRent(0);

        assertEq(gameToken.balanceOf(lender), 100 ether);
        
        (, , , , , , uint256 claimable) = vault.listings(0);
        assertEq(claimable, 0);
    }

    function test_ClaimRent_RevertNotLender() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(renter);
        vault.rentItem(0, 10);

        vm.prank(renter);
        vm.expectRevert("Not lender");
        vault.claimRent(0);
    }

    function test_ClaimRent_RevertNoRent() public {
        vm.prank(lender);
        vault.listItem(1, 5, 10 ether);

        vm.prank(lender);
        vm.expectRevert("No rent claimable");
        vault.claimRent(0);
    }
}
