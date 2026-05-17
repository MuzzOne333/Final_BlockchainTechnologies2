// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        );

    function decimals() external view returns (uint8);
}

contract ChainlinkForkTest is Test {

    AggregatorV3Interface constant feed =
        AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"));
    }

    function testLatestRoundData() public view {
        (, int256 answer, , , ) = feed.latestRoundData();

        assertGt(answer, 0);
    }

    function testDecimals() public view {
        assertEq(feed.decimals(), 8);
    }
}