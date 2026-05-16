// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

// =========================
// MUZAFFAR
// =========================

contract AMM is ERC1155Holder {
    IERC1155 public immutable resourceToken;

    // tokenId => reserve
    mapping(uint256 => uint256) public reserves;

    uint256 public constant FEE_NUMERATOR = 997; // 0.3% fee
    uint256 public constant FEE_DENOMINATOR = 1000;

    error InvalidAmount();
    error InsufficientLiquidity();
    error SlippageExceeded();

    constructor(IERC1155 _resourceToken) {
        resourceToken = _resourceToken;
    }

    // =========================
    // LIQUIDITY
    // =========================

    function addLiquidity(uint256 tokenId, uint256 amount) external {
        if (amount == 0) revert InvalidAmount();

        resourceToken.safeTransferFrom(
            msg.sender,
            address(this),
            tokenId,
            amount,
            ""
        );

        reserves[tokenId] += amount;
    }

    // =========================
    // SWAP
    // =========================

    function swap(
        uint256 fromId,
        uint256 toId,
        uint256 amountIn,
        uint256 minAmountOut
    ) external returns (uint256 amountOut) {
        if (amountIn == 0) revert InvalidAmount();

        uint256 reserveIn = reserves[fromId];
        uint256 reserveOut = reserves[toId];

        if (reserveIn == 0 || reserveOut == 0) {
            revert InsufficientLiquidity();
        }

        // transfer input token first
        resourceToken.safeTransferFrom(
            msg.sender,
            address(this),
            fromId,
            amountIn,
            ""
        );

        // fee: 0.3%
        uint256 amountInWithFee = amountIn * FEE_NUMERATOR;

        // constant product formula:
        // amountOut =
        // (amountInWithFee * reserveOut) /
        // (reserveIn * 1000 + amountInWithFee)

        amountOut =
            (amountInWithFee * reserveOut) /
            (reserveIn * FEE_DENOMINATOR + amountInWithFee);

        if (amountOut == 0 || amountOut > reserveOut) {
            revert InsufficientLiquidity();
        }

        if (amountOut < minAmountOut) {
            revert SlippageExceeded();
        }

        // update reserves
        reserves[fromId] = reserveIn + amountIn;
        reserves[toId] = reserveOut - amountOut;

        // transfer output token
        resourceToken.safeTransferFrom(
            address(this),
            msg.sender,
            toId,
            amountOut,
            ""
        );
    }

    // =========================
    // VIEW
    // =========================

    function getAmountOut(
        uint256 fromId,
        uint256 toId,
        uint256 amountIn
    ) external view returns (uint256) {
        uint256 reserveIn = reserves[fromId];
        uint256 reserveOut = reserves[toId];

        if (reserveIn == 0 || reserveOut == 0) {
            return 0;
        }

        uint256 amountInWithFee = amountIn * FEE_NUMERATOR;

        return
            (amountInWithFee * reserveOut) /
            (reserveIn * FEE_DENOMINATOR + amountInWithFee);
    }

    // =========================
    // YUL OPTIMIZATION
    // =========================

    function min(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := xor(a, mul(xor(a, b), lt(b, a)))
        }
    }
}