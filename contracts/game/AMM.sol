// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract AMM is ERC1155Holder {
    IERC1155 public immutable resourceToken;

    mapping(uint256 => uint256) public reserves;
    mapping(address => mapping(uint256 => uint256)) public lpBalances;

    uint256 public constant FEE_NUMERATOR = 997; 
    uint256 public constant FEE_DENOMINATOR = 1000;

    error InvalidAmount();
    error InsufficientLiquidity();
    error SlippageExceeded();

    event LiquidityAdded(address indexed provider, uint256 indexed tokenId, uint256 amount);
    event LiquidityRemoved(address indexed provider, uint256 indexed tokenId, uint256 amount);
    event Swapped(address indexed user, uint256 fromId, uint256 toId, uint256 amountIn, uint256 amountOut);

    constructor(IERC1155 _resourceToken) {
        resourceToken = _resourceToken;
    }

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
        lpBalances[msg.sender][tokenId] += amount;

        emit LiquidityAdded(msg.sender, tokenId, amount);
    }

    function removeLiquidity(uint256 tokenId, uint256 lpAmount) external {
        if (lpAmount == 0) revert InvalidAmount();
        if (lpBalances[msg.sender][tokenId] < lpAmount) revert InsufficientLiquidity();

        lpBalances[msg.sender][tokenId] -= lpAmount;
        reserves[tokenId] -= lpAmount;

        resourceToken.safeTransferFrom(
            address(this),
            msg.sender,
            tokenId,
            lpAmount,
            ""
        );

        emit LiquidityRemoved(msg.sender, tokenId, lpAmount);
    }

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

        // Apply CEI pattern properly
        uint256 amountInWithFee = amountIn * FEE_NUMERATOR;
        amountOut = (amountInWithFee * reserveOut) / (reserveIn * FEE_DENOMINATOR + amountInWithFee);

        if (amountOut == 0 || amountOut > reserveOut) {
            revert InsufficientLiquidity();
        }

        if (amountOut < minAmountOut) {
            revert SlippageExceeded();
        }

        reserves[fromId] = reserveIn + amountIn;
        reserves[toId] = reserveOut - amountOut;

        resourceToken.safeTransferFrom(
            msg.sender,
            address(this),
            fromId,
            amountIn,
            ""
        );

        resourceToken.safeTransferFrom(
            address(this),
            msg.sender,
            toId,
            amountOut,
            ""
        );

        emit Swapped(msg.sender, fromId, toId, amountIn, amountOut);
    }

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
}