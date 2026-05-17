// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "contracts/game/CraftingSystem.sol";

contract MockResourceTokens {
    mapping(address => mapping(uint256 => uint256)) public balances;

    function burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) external {
        for (uint i = 0; i < ids.length; i++) {
            require(balances[account][ids[i]] >= amounts[i], "Insufficient balance");
            balances[account][ids[i]] -= amounts[i];
        }
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory) external {
        balances[account][id] += amount;
    }

    // test helper
    function testMint(address account, uint256 id, uint256 amount) external {
        balances[account][id] += amount;
    }
}

contract CraftingSystemTest is Test {
    CraftingSystem crafting;
    MockResourceTokens token;

    address admin = address(this);
    address crafter = address(0x1);
    address user = address(0x2);

    function setUp() public {
        token = new MockResourceTokens();
        crafting = new CraftingSystem(address(token));

        crafting.grantRole(crafting.CRAFTER_ROLE(), crafter);
    }

    function test_AddRecipe() public {
        uint256[] memory inputs = new uint256[](2);
        inputs[0] = 1; inputs[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10; amounts[1] = 5;

        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs,
            inputAmounts: amounts,
            outputId: 3,
            outputAmount: 1
        });

        vm.expectEmit(true, false, false, true);
        emit CraftingSystem.RecipeAdded(0, 3);
        crafting.addRecipe(recipe);

        (uint256 outId, uint256 outAmt) = crafting.recipes(0);
        assertEq(outId, 3);
        assertEq(outAmt, 1);
        assertEq(crafting.nextRecipeId(), 1);
    }

    function test_AddRecipe_RevertNotAdmin() public {
        uint256[] memory inputs = new uint256[](1); inputs[0] = 1;
        uint256[] memory amounts = new uint256[](1); amounts[0] = 10;

        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs,
            inputAmounts: amounts,
            outputId: 3,
            outputAmount: 1
        });

        vm.prank(user);
        vm.expectRevert();
        crafting.addRecipe(recipe);
    }

    function test_AddRecipe_RevertLengthMismatch() public {
        uint256[] memory inputs = new uint256[](2); inputs[0] = 1; inputs[1] = 2;
        uint256[] memory amounts = new uint256[](1); amounts[0] = 10;

        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs,
            inputAmounts: amounts,
            outputId: 3,
            outputAmount: 1
        });

        vm.expectRevert("Length mismatch");
        crafting.addRecipe(recipe);
    }

    function test_AddRecipe_RevertEmptyInputs() public {
        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: new uint256[](0),
            inputAmounts: new uint256[](0),
            outputId: 3,
            outputAmount: 1
        });

        vm.expectRevert("Empty inputs");
        crafting.addRecipe(recipe);
    }

    function test_Craft() public {
        uint256[] memory inputs = new uint256[](2); inputs[0] = 1; inputs[1] = 2;
        uint256[] memory amounts = new uint256[](2); amounts[0] = 10; amounts[1] = 5;

        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs,
            inputAmounts: amounts,
            outputId: 3,
            outputAmount: 1
        });

        crafting.addRecipe(recipe);

        token.testMint(crafter, 1, 10);
        token.testMint(crafter, 2, 5);

        vm.prank(crafter);
        vm.expectEmit(true, true, false, true);
        emit CraftingSystem.ItemCrafted(crafter, 0, 3, 1);
        crafting.craft(0);

        assertEq(token.balances(crafter, 1), 0);
        assertEq(token.balances(crafter, 2), 0);
        assertEq(token.balances(crafter, 3), 1);
    }

    function test_Craft_RevertInvalidRecipe() public {
        vm.prank(crafter);
        vm.expectRevert("Invalid recipe");
        crafting.craft(0);
    }

    function test_Craft_RevertNotCrafter() public {
        uint256[] memory inputs = new uint256[](1); inputs[0] = 1;
        uint256[] memory amounts = new uint256[](1); amounts[0] = 10;
        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs, inputAmounts: amounts, outputId: 3, outputAmount: 1
        });
        crafting.addRecipe(recipe);

        vm.prank(user);
        vm.expectRevert();
        crafting.craft(0);
    }

    function test_Craft_RevertInsufficientBalance() public {
        uint256[] memory inputs = new uint256[](1); inputs[0] = 1;
        uint256[] memory amounts = new uint256[](1); amounts[0] = 10;
        CraftingSystem.Recipe memory recipe = CraftingSystem.Recipe({
            inputIds: inputs, inputAmounts: amounts, outputId: 3, outputAmount: 1
        });
        crafting.addRecipe(recipe);

        token.testMint(crafter, 1, 5); // Only 5, needs 10

        vm.prank(crafter);
        vm.expectRevert("Insufficient balance");
        crafting.craft(0);
    }
}
