// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/governance/GameTimelock.sol";
import "../src/governance/GameGovernor.sol";

contract Verify is Script {
    function run() external view {
        address timelockAddr = vm.envAddress("TIMELOCK_ADDRESS");
        address governorAddr = vm.envAddress("GOVERNOR_ADDRESS");

        GameTimelock timelock = GameTimelock(payable(timelockAddr));
        GameGovernor governor = GameGovernor(payable(governorAddr));

        require(timelock.getMinDelay() == 2 days, "Wrong timelock delay");
        require(governor.votingDelay() == 1 days, "Wrong voting delay");
        require(governor.votingPeriod() == 1 weeks, "Wrong voting period");
        require(governor.timelock() == timelockAddr, "Wrong timelock in governor");

        console.log("All checks passed");
        console.log("Timelock delay: ", timelock.getMinDelay());
        console.log("Voting delay:   ", governor.votingDelay());
        console.log("Voting period:  ", governor.votingPeriod());
    }
}
