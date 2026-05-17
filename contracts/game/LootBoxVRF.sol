// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IResourceTokens is IERC1155 {
    function mint(address account, uint256 id, uint256 amount, bytes memory data) external;
}

contract LootBoxVRF is VRFConsumerBaseV2Plus {
    IResourceTokens public immutable resourceToken;
    uint256 public immutable subscriptionId;
    bytes32 public immutable keyHash;
    uint32 public immutable callbackGasLimit;
    uint16 public constant REQUEST_CONFIRMATIONS = 3;
    uint32 public constant NUM_WORDS = 1;

    mapping(uint256 => address) public requestToSender;

    event LootBoxOpened(address indexed user, uint256 requestId);
    event RewardMinted(address indexed user, uint256 indexed tokenId, uint256 amount);

    constructor(
        address _vrfCoordinator,
        uint256 _subscriptionId,
        bytes32 _keyHash,
        uint32 _callbackGasLimit,
        address _resourceToken
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) {
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        callbackGasLimit = _callbackGasLimit;
        resourceToken = IResourceTokens(_resourceToken);
    }

    function openLootBox() external payable returns (uint256 requestId) {
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
        requestToSender[requestId] = msg.sender;
        emit LootBoxOpened(msg.sender, requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        address user = requestToSender[requestId];
        uint256 randomValue = randomWords[0] % 100;
        
        uint256 tokenId;
        uint256 amount = 1;

        if (randomValue < 60) {
            tokenId = 1; // Common
        } else if (randomValue < 90) {
            tokenId = 2; // Rare
        } else {
            tokenId = 3; // Legendary
        }

        resourceToken.mint(user, tokenId, amount, "");
        emit RewardMinted(user, tokenId, amount);
    }
}

contract MockVRFCoordinator {
    uint256 private s_nextRequestId = 1;
    mapping(uint256 => address) private s_consumers;

    function requestRandomWords(VRFV2PlusClient.RandomWordsRequest calldata req) external returns (uint256) {
        uint256 requestId = s_nextRequestId++;
        s_consumers[requestId] = msg.sender;
        return requestId;
    }

    function fulfillRandomWords(uint256 requestId, address consumer, uint256[] calldata randomWords) external {
        VRFConsumerBaseV2Plus(consumer).rawFulfillRandomWords(requestId, randomWords);
    }
}
