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

contract VaultFuzzTest is Test {
    MockERC20 token;
    StakingVault vault;

    address alice = address(1);

    function setUp() public {
        token = new MockERC20();
        vault = new StakingVault(token);

        token.mint(alice, type(uint128).max);

        vm.prank(alice);
        token.approve(address(vault), type(uint256).max);
    }

    function testFuzzDeposit(uint96 amount) public {
        vm.assume(amount > 0);

        vm.prank(alice);
        vault.deposit(amount, alice);

        assertEq(vault.maxWithdraw(alice), amount);
    }

    function testFuzzWithdraw(
        uint96 depositAmount,
        uint96 withdrawAmount
    ) public {
        vm.assume(depositAmount > 0);
        vm.assume(withdrawAmount <= depositAmount);

        vm.startPrank(alice);

        vault.deposit(depositAmount, alice);
        vault.withdraw(withdrawAmount, alice, alice);

        vm.stopPrank();

        assertEq(vault.maxWithdraw(alice), depositAmount - withdrawAmount);
    }

    function testFuzzMint(uint96 shares) public {
        vm.assume(shares > 0);

        vm.prank(alice);
        uint256 assets = vault.mint(shares, alice);

        assertEq(assets, shares);
        assertEq(vault.maxWithdraw(alice), shares);
    }

    function testFuzzRedeem(
        uint96 mintShares,
        uint96 redeemShares
    ) public {
        vm.assume(mintShares > 0);
        vm.assume(redeemShares <= mintShares);

        vm.startPrank(alice);

        vault.mint(mintShares, alice);
        vault.redeem(redeemShares, alice, alice);

        vm.stopPrank();

        assertEq(vault.maxWithdraw(alice), mintShares - redeemShares);
    }
}
