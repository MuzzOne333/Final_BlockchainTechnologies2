// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "contracts/libraries/StakingVault.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock", "MOCK") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract StakingVaultTest is Test {
    MockERC20 token;
    StakingVault vault;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new MockERC20();
        vault = new StakingVault(token);

        token.mint(alice, 1_000_000 ether);
        token.mint(bob, 1_000_000 ether);

        vm.prank(alice);
        token.approve(address(vault), type(uint256).max);

        vm.prank(bob);
        token.approve(address(vault), type(uint256).max);
    }

    function testDeposit() public {
        vm.prank(alice);
        vault.deposit(100 ether, alice);

        assertEq(vault.maxWithdraw(alice), 100 ether);
        assertEq(vault.totalAssets(), 100 ether);
    }

    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);

    function testDepositEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Deposit(alice, alice, 100 ether, 100 ether);

        vm.prank(alice);
        vault.deposit(100 ether, alice);
    }

    function testWithdraw() public {
        vm.startPrank(alice);

        vault.deposit(100 ether, alice);
        vault.withdraw(40 ether, alice, alice);

        vm.stopPrank();

        assertEq(vault.maxWithdraw(alice), 60 ether);
        assertEq(vault.totalAssets(), 60 ether);
    }

    function testFullWithdraw() public {
        vm.startPrank(alice);

        vault.deposit(100 ether, alice);
        vault.withdraw(100 ether, alice, alice);

        vm.stopPrank();

        assertEq(vault.maxWithdraw(alice), 0);
        assertEq(vault.totalAssets(), 0);
    }

    function testCannotWithdrawTooMuch() public {
        vm.startPrank(alice);

        vault.deposit(100 ether, alice);

        vm.expectRevert();
        vault.withdraw(101 ether, alice, alice);

        vm.stopPrank();
    }

    function testMultipleUsers() public {
        vm.prank(alice);
        vault.deposit(100 ether, alice);

        vm.prank(bob);
        vault.deposit(300 ether, bob);

        assertEq(vault.totalAssets(), 400 ether);
    }

    function testVaultBalanceMatchesAccounting() public {
        vm.prank(alice);
        vault.deposit(100 ether, alice);

        vm.prank(bob);
        vault.deposit(200 ether, bob);

        assertEq(
            token.balanceOf(address(vault)),
            vault.totalAssets()
        );
    }

    function testMint() public {
        vm.prank(alice);
        uint256 assets = vault.mint(100 ether, alice);

        assertEq(assets, 100 ether);
        assertEq(vault.maxWithdraw(alice), 100 ether);
        assertEq(vault.totalAssets(), 100 ether);
    }

    function testRedeem() public {
        vm.startPrank(alice);
        vault.mint(100 ether, alice);
        uint256 assets = vault.redeem(40 ether, alice, alice);
        vm.stopPrank();

        assertEq(assets, 40 ether);
        assertEq(vault.maxWithdraw(alice), 60 ether);
        assertEq(vault.totalAssets(), 60 ether);
    }

    function testPreviewDeposit() public view {
        uint256 shares = vault.previewDeposit(100 ether);
        assertEq(shares, 100 ether);
    }

    function testPreviewMint() public view {
        uint256 assets = vault.previewMint(100 ether);
        assertEq(assets, 100 ether);
    }

    function testPreviewWithdraw() public view {
        uint256 shares = vault.previewWithdraw(100 ether);
        assertEq(shares, 100 ether);
    }

    function testPreviewRedeem() public view {
        uint256 assets = vault.previewRedeem(100 ether);
        assertEq(assets, 100 ether);
    }
}