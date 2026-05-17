// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "contracts/game/AMM.sol";
import "contracts/game/ResourceTokens.sol";
import "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/// @notice Handler for fuzzing AMM
contract Handler is Test, IERC1155Receiver {
    AMM public amm;
    ResourceTokens public token;

    constructor(AMM _amm, ResourceTokens _token) {
        amm = _amm;
        token = _token;

        // Mint tokens for the handler
        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);

        token.setApprovalForAll(address(amm), true);
    }

    function swap(uint256 amount) public {
        amount = bound(amount, 1 ether, 1000 ether);
        try amm.swap(1, 2, amount, 0) {} catch {}
    }

    // ===== ERC1155 Receiver =====
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) external pure override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) external pure override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }
}

/// @notice Invariant test for AMM
contract AMMInvariantFixed is StdInvariant, Test {
    AMM public amm;
    ResourceTokens public token;
    Handler public handler;

    function setUp() public {
        // Deploy token and AMM
        token = new ResourceTokens();
        amm = new AMM(token);

        // Deploy handler
        handler = new Handler(amm, token);

        // Add initial liquidity
        token.setApprovalForAll(address(amm), true);
        amm.addLiquidity(1, 500_000 ether);
        amm.addLiquidity(2, 500_000 ether);

        // Set target contract for invariant testing
        targetContract(address(handler));
    }

    /// @notice Invariant: the AMM product (K) never decreases
    function invariant_KNeverDecreases() public view {
        uint256 reserve1 = amm.reserves(1);
        uint256 reserve2 = amm.reserves(2);

        uint256 minK = 250_000_000_000 * 1e18 * 1e18; // 250B * 1 ether * 1 ether
        assertGe(reserve1 * reserve2, minK);
    }
}