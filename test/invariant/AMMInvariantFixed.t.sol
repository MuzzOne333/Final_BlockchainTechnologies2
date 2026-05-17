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

        token.setApprovalForAll(address(amm), true);
    }

    uint256 public totalSwaps;

    function swap(uint256 amount) public {
        amount = bound(amount, 1 ether, 1000 ether);
        try amm.swap(1, 2, amount, 0) {
            totalSwaps++;
        } catch {}
    }

    function swapReverse(uint256 amount) public {
        amount = bound(amount, 1 ether, 1000 ether);
        try amm.swap(2, 1, amount, 0) {
            totalSwaps++;
        } catch {}
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
contract AMMInvariantFixed is StdInvariant, Test, IERC1155Receiver {
    AMM public amm;
    ResourceTokens public token;
    Handler public handler;

    function setUp() public {
        // Deploy token and AMM
        token = new ResourceTokens();
        amm = new AMM(token);

        // Deploy handler
        // Deploy handler
        handler = new Handler(amm, token);

        // Mint tokens for the handler and the test contract
        token.mint(address(this), 1, 1_000_000 ether);
        token.mint(address(this), 2, 1_000_000 ether);
        token.mint(address(handler), 1, 1_000_000 ether);
        token.mint(address(handler), 2, 1_000_000 ether);

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

    /// @notice Invariant: AMM token balance must match its internal reserves
    function invariant_BalancesMatchReserves() public view {
        assertEq(token.balanceOf(address(amm), 1), amm.reserves(1));
        assertEq(token.balanceOf(address(amm), 2), amm.reserves(2));
    }

    /// @notice Invariant: Total supply conservation (AMM balance + Handler balance + Test contract balance = total minted)
    function invariant_TotalSupplyConservation() public view {
        uint256 totalMinted1 = 2_000_000 ether; // 1m to test contract, 1m to handler
        uint256 totalMinted2 = 2_000_000 ether;

        uint256 currentTotal1 = token.balanceOf(address(amm), 1) + token.balanceOf(address(handler), 1) + token.balanceOf(address(this), 1);
        uint256 currentTotal2 = token.balanceOf(address(amm), 2) + token.balanceOf(address(handler), 2) + token.balanceOf(address(this), 2);

        assertEq(currentTotal1, totalMinted1);
        assertEq(currentTotal2, totalMinted2);
    }

    /// @notice Invariant: Reserves must grow over time due to fees if swaps occurred
    function invariant_ReservesGrow() public view {
        if (handler.totalSwaps() > 0) {
            // Because of the 0.3% fee, the sum of reserves should generally increase or K should increase
            // Actually, the simplest check is that K is strictly greater than initial K if swaps happened
            uint256 minK = 250_000_000_000 * 1e18 * 1e18;
            assertGt(amm.reserves(1) * amm.reserves(2), minK);
        }
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