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
        vault.deposit(100 ether);

        assertEq(vault.userDeposits(alice), 100 ether);
        assertEq(vault.totalDeposits(), 100 ether);
    }

    function testDepositEmitsEvent() public {
        vm.expectEmit(true, false, false, true);
        emit StakingVault.Deposited(alice, 100 ether);

        vm.prank(alice);
        vault.deposit(100 ether);
    }

    function testCannotDepositZero() public {
        vm.expectRevert("ZERO_AMOUNT");

        vm.prank(alice);
        vault.deposit(0);
    }

    function testWithdraw() public {
        vm.startPrank(alice);

        vault.deposit(100 ether);
        vault.withdraw(40 ether);

        vm.stopPrank();

        assertEq(vault.userDeposits(alice), 60 ether);
        assertEq(vault.totalDeposits(), 60 ether);
    }

    function testFullWithdraw() public {
        vm.startPrank(alice);

        vault.deposit(100 ether);
        vault.withdraw(100 ether);

        vm.stopPrank();

        assertEq(vault.userDeposits(alice), 0);
        assertEq(vault.totalDeposits(), 0);
    }

    function testCannotWithdrawTooMuch() public {
        vm.startPrank(alice);

        vault.deposit(100 ether);

        vm.expectRevert("INSUFFICIENT");
        vault.withdraw(101 ether);

        vm.stopPrank();
    }

    function testRewardCalculation() public {
        vm.prank(alice);
        vault.deposit(100 ether);

        uint256 reward = vault.calculateReward(alice);

        assertEq(reward, 10 ether);
    }

    function testMultipleUsers() public {
        vm.prank(alice);
        vault.deposit(100 ether);

        vm.prank(bob);
        vault.deposit(300 ether);

        assertEq(vault.totalDeposits(), 400 ether);
    }

    function testVaultBalanceMatchesAccounting() public {
        vm.prank(alice);
        vault.deposit(100 ether);

        vm.prank(bob);
        vault.deposit(200 ether);

        assertEq(
            token.balanceOf(address(vault)),
            vault.totalDeposits()
        );
    }
}