// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract NFTRentalVault is ERC1155Holder, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC1155 public immutable resourceToken;
    IERC20 public immutable gameToken;

    struct Listing {
        address lender;
        uint256 tokenId;
        uint256 amount;
        uint256 pricePerBlock;
        address renter;
        uint256 rentalEnd;
        uint256 claimableRent;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public nextListingId;

    event ItemListed(uint256 indexed listingId, address indexed lender, uint256 tokenId, uint256 amount, uint256 pricePerBlock);
    event ItemRented(uint256 indexed listingId, address indexed renter, uint256 blocks);
    event ItemClaimedBack(uint256 indexed listingId, address indexed lender);
    event RentClaimed(uint256 indexed listingId, address indexed lender, uint256 amount);

    constructor(address _resourceToken, address _gameToken) {
        resourceToken = IERC1155(_resourceToken);
        gameToken = IERC20(_gameToken);
    }

    function listItem(uint256 tokenId, uint256 amount, uint256 pricePerBlock) external nonReentrant returns (uint256 listingId) {
        require(amount > 0, "Zero amount");
        require(pricePerBlock > 0, "Zero price");

        resourceToken.safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        listingId = nextListingId++;
        listings[listingId] = Listing({
            lender: msg.sender,
            tokenId: tokenId,
            amount: amount,
            pricePerBlock: pricePerBlock,
            renter: address(0),
            rentalEnd: 0,
            claimableRent: 0
        });

        emit ItemListed(listingId, msg.sender, tokenId, amount, pricePerBlock);
    }

    function rentItem(uint256 listingId, uint256 blocks) external nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.amount > 0, "Listing not available");
        require(listing.renter == address(0) || block.number > listing.rentalEnd, "Already rented");
        require(blocks > 0, "Zero blocks");

        uint256 cost = blocks * listing.pricePerBlock;
        gameToken.safeTransferFrom(msg.sender, address(this), cost);

        listing.renter = msg.sender;
        listing.rentalEnd = block.number + blocks;
        listing.claimableRent += cost;

        emit ItemRented(listingId, msg.sender, blocks);
    }

    function claimBack(uint256 listingId) external nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.lender == msg.sender, "Not lender");
        require(block.number > listing.rentalEnd, "Rental active");

        uint256 amount = listing.amount;
        uint256 tokenId = listing.tokenId;

        listing.amount = 0; // mark as closed

        resourceToken.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        emit ItemClaimedBack(listingId, msg.sender);
    }

    function claimRent(uint256 listingId) external nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.lender == msg.sender, "Not lender");

        uint256 rent = listing.claimableRent;
        require(rent > 0, "No rent claimable");

        listing.claimableRent = 0;

        gameToken.safeTransfer(msg.sender, rent);

        emit RentClaimed(listingId, msg.sender, rent);
    }
}
