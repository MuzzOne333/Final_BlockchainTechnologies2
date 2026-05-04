// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;




interface IGameItems {
    function mint(address account, uint256 id, uint256 amount) external;
}



contract LootBox {
    // TODO: нужен ERC1155
    IGameItems public gameItems;

    // TODO: Цена лутбокса нужна
    uint256 public lootBoxPrice;

    event LootBoxOpened(address indexed player, uint256 itemId);

    constructor(address _gameItems, uint256 _lootBoxPrice) {
        // TODO: нужны значения
        gameItems = IGameItems(_gameItems);
        lootBoxPrice = _lootBoxPrice;
    }

    function openLootBox() external payable{
        /// TODO: заменить проверку, когда будет готова экономика (ERC20 / vault)
        require(msg.value >= lootBoxPrice, "Not enough payment");

         /// ВРЕМЕННЫЙ RANDOM (потом заменить на VRF) проверка работает или нет
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    msg.sender
                )
            )
        );

        uint256 itemId = _getRandomItem(random);

        gameItems.mint(msg.sender, itemId, 1);

        emit LootBoxOpened(msg.sender, itemId);
    }

    // Определение предмета по редкости

    function _getRandomItem(uint256 random) internal pure returns (uint256) {
        uint256 chance = random % 100;

        if (chance < 60) {
            return 1; // Серый предмет
        } else if (chance < 85) {
            return 2; // синий предмет
        } else if (chance < 97) {
            return 3; // фиолетовый предмет
        } else {
            return 4; // Золотой предмет
        }
    }
}