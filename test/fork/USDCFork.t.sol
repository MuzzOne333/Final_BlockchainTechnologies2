// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract USDCForkTest is Test {
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    function setUp() public {
        string memory rpcUrl = vm.envOr("MAINNET_RPC_URL", string("https://eth.drpc.org"));
        vm.createSelectFork(rpcUrl);
    }

    function testUSDCTransferAndBalance() public {
        // Impersonate Binance hot wallet or any large USDC holder
        address largeHolder = 0x28C6c06298d514Db089934071355E5743bf21d60; // Binance 14
        
        vm.prank(largeHolder);
        usdc.transfer(address(this), 1000 * 10**6); // Transfer 1000 USDC

        assertEq(usdc.balanceOf(address(this)), 1000 * 10**6);
    }
}
