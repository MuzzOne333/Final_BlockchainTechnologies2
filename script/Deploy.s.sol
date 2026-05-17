// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/governance/GameToken.sol";
import "../src/governance/GameTimelock.sol";
import "../src/governance/GameGovernor.sol";

contract Deploy is Script {
    function run() external {
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");
        vm.startBroadcast();

        GameToken token = new GameToken(deployer);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        executors[0] = address(0);

        GameTimelock timelock = new GameTimelock(2 days, proposers, executors, deployer);
        GameGovernor governor = new GameGovernor(IVotes(address(token)), timelock);

        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.CANCELLER_ROLE(), address(governor));
        timelock.revokeRole(timelock.DEFAULT_ADMIN_ROLE(), deployer);

        vm.stopBroadcast();

        console.log("GameToken:    ", address(token));
        console.log("GameTimelock: ", address(timelock));
        console.log("GameGovernor: ", address(governor));
    }
}
