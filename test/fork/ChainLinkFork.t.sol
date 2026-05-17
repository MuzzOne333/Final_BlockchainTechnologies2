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

    AggregatorV3Interface constant ethUsdFeed =
        AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );

    AggregatorV3Interface constant usdcUsdFeed =
        AggregatorV3Interface(
            0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6
        );

    function setUp() public {
        string memory rpcUrl = vm.envOr("MAINNET_RPC_URL", string("https://eth.drpc.org"));
        vm.createSelectFork(rpcUrl);
    }

    function testLatestRoundData() public view {
        (, int256 answerEth, , , ) = ethUsdFeed.latestRoundData();
        assertGt(answerEth, 0);

        (, int256 answerUsdc, , , ) = usdcUsdFeed.latestRoundData();
        assertGt(answerUsdc, 0);
    }

    function testDecimals() public view {
        assertEq(ethUsdFeed.decimals(), 8);
        assertEq(usdcUsdFeed.decimals(), 8);
    }
}