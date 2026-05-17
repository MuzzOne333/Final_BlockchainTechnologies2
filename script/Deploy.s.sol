// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/governance/GameToken.sol";
import "../src/governance/GameTimelock.sol";
import "../src/governance/GameGovernor.sol";
import "../contracts/game/ResourceTokens.sol";
import "../contracts/game/AMM.sol";
import "../contracts/libraries/StakingVault.sol";
import "../contracts/game/NFTRentalVault.sol";
import "../contracts/game/CraftingSystem.sol";
import "../contracts/game/LootBox.sol";

contract Deploy is Script {
    function run() external {
        address deployer = vm.envOr("DEPLOYER_ADDRESS", msg.sender);
        vm.startBroadcast(deployer);

        // 1. Deploy Tokens
        GameToken gameToken = new GameToken(deployer);
        ResourceTokens resourceTokens = new ResourceTokens();

        // 2. Deploy Game Components
        AMM amm = new AMM(resourceTokens);
        StakingVault stakingVault = new StakingVault(gameToken);
        NFTRentalVault rentalVault = new NFTRentalVault(address(resourceTokens), address(gameToken));
        CraftingSystem craftingSystem = new CraftingSystem(address(resourceTokens));
        
        // LootBox requires the GameItems address (ResourceTokens) and a price
        uint256 lootBoxPrice = 100 ether; // 100 game tokens per lootbox
        LootBox lootBox = new LootBox(address(resourceTokens), lootBoxPrice);

        // 3. Deploy Governance
        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        executors[0] = address(0);

        GameTimelock timelock = new GameTimelock(2 days, proposers, executors, deployer);
        GameGovernor governor = new GameGovernor(IVotes(address(gameToken)), timelock);

        // 4. Setup Roles and Ownership
        // Setup Governance Roles
        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.CANCELLER_ROLE(), address(governor));

        // Let the DAO control the game components
        resourceTokens.transferOwnership(address(timelock));
        craftingSystem.grantRole(craftingSystem.DEFAULT_ADMIN_ROLE(), address(timelock));
        
        // Relinquish deployer's admin role on timelock so it is purely DAO governed
        timelock.revokeRole(timelock.DEFAULT_ADMIN_ROLE(), deployer);

        vm.stopBroadcast();

        console.log("=== Deployment Addresses ===");
        console.log("GameToken:      ", address(gameToken));
        console.log("ResourceTokens: ", address(resourceTokens));
        console.log("AMM:            ", address(amm));
        console.log("StakingVault:   ", address(stakingVault));
        console.log("NFTRentalVault: ", address(rentalVault));
        console.log("CraftingSystem: ", address(craftingSystem));
        console.log("LootBox:        ", address(lootBox));
        console.log("GameTimelock:   ", address(timelock));
        console.log("GameGovernor:   ", address(governor));
    }
}
