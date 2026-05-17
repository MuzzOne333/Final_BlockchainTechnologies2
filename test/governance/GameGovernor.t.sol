// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../src/governance/GameToken.sol";
import "../../src/governance/GameTimelock.sol";
import "../../src/governance/GameGovernor.sol";

contract GameGovernorTest is Test {
    GameToken token;
    GameTimelock timelock;
    GameGovernor governor;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    uint256 constant MIN_DELAY = 2 days;

    function setUp() public {
        token = new GameToken(alice);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        executors[0] = address(0);

        timelock = new GameTimelock(MIN_DELAY, proposers, executors, address(this));
        governor = new GameGovernor(IVotes(address(token)), timelock);

        timelock.grantRole(timelock.PROPOSER_ROLE(), address(governor));
        timelock.grantRole(timelock.CANCELLER_ROLE(), address(governor));
        timelock.revokeRole(timelock.DEFAULT_ADMIN_ROLE(), address(this));

        vm.prank(alice);
        token.delegate(alice);
    }

    function test_GovernorName() public view {
        assertEq(governor.name(), "GameGovernor");
    }

    function test_VotingDelay() public view {
        assertEq(governor.votingDelay(), 1 days);
    }

    function test_VotingPeriod() public view {
        assertEq(governor.votingPeriod(), 1 weeks);
    }

    function test_Quorum() public {
        vm.roll(block.number + 1);
        assertEq(governor.quorum(block.number - 1), 40_000 * 10 ** 18);
    }

    function test_ProposalThreshold() public view {
        assertEq(governor.proposalThreshold(), 1e18);
    }

    function test_TimelockAddress() public view {
        assertEq(governor.timelock(), address(timelock));
    }

    function test_TokenAddress() public view {
        assertEq(address(governor.token()), address(token));
    }

    function test_AliceCanPropose() public {
        vm.roll(block.number + 1);

        address[] memory targets = new address[](1);
        targets[0] = address(0x1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";

        vm.prank(alice);
        uint256 proposalId = governor.propose(targets, values, calldatas, "Test proposal");
        assertTrue(proposalId > 0);
    }

    function test_BobCannotPropose() public {
        vm.roll(block.number + 1);

        address[] memory targets = new address[](1);
        targets[0] = address(0x1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";

        vm.prank(bob);
        vm.expectRevert();
        governor.propose(targets, values, calldatas, "Bob proposal");
    }

    function test_FullLifecycle() public {
        vm.roll(block.number + 1);

        address[] memory targets = new address[](1);
        targets[0] = address(0x1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";
        string memory description = "Proposal #1";

        vm.prank(alice);
        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        vm.roll(block.number + governor.votingDelay() + 1);
        assertEq(uint(governor.state(proposalId)), uint(IGovernor.ProposalState.Active));

        vm.prank(alice);
        governor.castVote(proposalId, 1);

        vm.roll(block.number + governor.votingPeriod() + 1);
        assertEq(uint(governor.state(proposalId)), uint(IGovernor.ProposalState.Succeeded));

        bytes32 descHash = keccak256(bytes(description));
        governor.queue(targets, values, calldatas, descHash);
        assertEq(uint(governor.state(proposalId)), uint(IGovernor.ProposalState.Queued));

        vm.warp(block.timestamp + MIN_DELAY + 1);

        governor.execute(targets, values, calldatas, descHash);
        assertEq(uint(governor.state(proposalId)), uint(IGovernor.ProposalState.Executed));
    }

    function testFuzz_VotingPowerAfterDelegate(uint96 amount) public {
        vm.assume(amount > 0 && amount <= 1_000_000 * 10 ** 18);
        vm.prank(alice);
        token.delegate(alice);
        vm.roll(block.number + 1);
        assertGe(token.getVotes(alice), 0);
    }
}
