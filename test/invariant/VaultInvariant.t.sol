// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "contracts/libraries/StakingVault.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock", "MOCK") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract VaultHandler is Test {
    StakingVault public vault;
    MockERC20 public token;

    constructor(StakingVault _vault, MockERC20 _token) {
        vault = _vault;
        token = _token;
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 1, 100_000 ether);
        token.mint(address(this), amount);
        token.approve(address(vault), amount);
        vault.deposit(amount, address(this));
    }

    function withdraw(uint256 amount) public {
        uint256 max = vault.maxWithdraw(address(this));
        if (max == 0) return;
        amount = bound(amount, 1, max);
        vault.withdraw(amount, address(this), address(this));
    }
}

contract VaultInvariant is StdInvariant, Test {
    StakingVault public vault;
    MockERC20 public token;
    VaultHandler public handler;

    function setUp() public {
        token = new MockERC20();
        vault = new StakingVault(token);
        handler = new VaultHandler(vault, token);

        targetContract(address(handler));
    }

    /// @notice Invariant: Total assets in the vault must always be >= total supply of shares
    /// In this mock without yield generation, it should be exactly equal, but if someone sends tokens directly it could be greater.
    function invariant_StakingShares() public view {
        assertGe(vault.totalAssets(), vault.totalSupply());
    }
}
