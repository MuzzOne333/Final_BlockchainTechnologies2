// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

interface IResourceTokens {
    function burnBatch(address account, uint256[] memory ids, uint256[] memory values) external;
    function mint(address account, uint256 id, uint256 amount, bytes memory data) external;
}

contract CraftingSystem is AccessControl {
    bytes32 public constant CRAFTER_ROLE = keccak256("CRAFTER_ROLE");

    struct Recipe {
        uint256[] inputIds;
        uint256[] inputAmounts;
        uint256 outputId;
        uint256 outputAmount;
    }

    IResourceTokens public immutable resourceToken;
    mapping(uint256 => Recipe) public recipes;
    uint256 public nextRecipeId;

    event RecipeAdded(uint256 indexed recipeId, uint256 outputId);
    event ItemCrafted(address indexed user, uint256 indexed recipeId, uint256 outputId, uint256 outputAmount);

    constructor(address _resourceToken) {
        resourceToken = IResourceTokens(_resourceToken);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CRAFTER_ROLE, msg.sender);
    }

    function addRecipe(Recipe calldata recipe) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(recipe.inputIds.length == recipe.inputAmounts.length, "Length mismatch");
        require(recipe.inputIds.length > 0, "Empty inputs");
        
        recipes[nextRecipeId] = recipe;
        emit RecipeAdded(nextRecipeId, recipe.outputId);
        nextRecipeId++;
    }

    function craft(uint256 recipeId) external onlyRole(CRAFTER_ROLE) {
        require(recipeId < nextRecipeId, "Invalid recipe");
        Recipe memory recipe = recipes[recipeId];

        resourceToken.burnBatch(msg.sender, recipe.inputIds, recipe.inputAmounts);
        resourceToken.mint(msg.sender, recipe.outputId, recipe.outputAmount, "");

        emit ItemCrafted(msg.sender, recipeId, recipe.outputId, recipe.outputAmount);
    }
}
