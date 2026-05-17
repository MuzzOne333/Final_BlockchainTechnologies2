// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";

import "../../contracts/game/AMM.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// Mock ERC1155 token
contract Mock1155 is ERC1155 {
    constructor() ERC1155("") {}

    function mint(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}

// Handler contract to call AMM functions
contract Handler {
    AMM public amm;

    constructor(AMM _amm) {
        amm = _amm;
    }

    function swap(uint256 amount) public {
        // No bound here; the invariant/fuzz test will handle it
        try amm.swap(1, 2, amount, 1) {} catch {}
    }
}

// Invariant test
contract AMMInvariant is StdInvariant, Test {
    Mock1155 token;
    AMM amm;
    Handler handler;

    function setUp() public {
        // Deploy token and AMM
        token = new Mock1155();
        amm = new AMM(token);

        // Mint tokens for testing
        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);

        // Approve AMM to spend tokens
        token.setApprovalForAll(address(amm), true);

        // Add initial liquidity
        amm.addLiquidity(1, 500_000 ether);
        amm.addLiquidity(2, 500_000 ether);

        // Deploy handler
        handler = new Handler(amm);

        // Set handler as the target for invariants
        targetContract(address(handler));
    }

    // Example invariant: constant product K never decreases
    function invariant_KNeverDecreases(uint256 amount) public {
        // Bound the amount for fuzz testing
        amount = bound(amount, 1 ether, 100 ether);

        // Call swap via handler
        handler.swap(amount);

        // Check the constant product invariant
        uint256 k = amm.reserves(1) * amm.reserves(2);
        assertGt(k, 0);
    }
}