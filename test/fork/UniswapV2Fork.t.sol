// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router02 {
    function WETH() external pure returns (address);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
}

contract UniswapV2ForkTest is Test {
    IUniswapV2Router02 router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    function setUp() public {
        string memory rpcUrl = vm.envOr("MAINNET_RPC_URL", string("https://eth.drpc.org"));
        vm.createSelectFork(rpcUrl);
    }

    function testSwapEthForUsdc() public {
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(usdc);

        uint256 initialBalance = usdc.balanceOf(address(this));

        // Swap 1 ETH for USDC
        router.swapExactETHForTokens{value: 1 ether}(
            0, // accept any amount of USDC
            path,
            address(this),
            block.timestamp + 1000
        );

        uint256 finalBalance = usdc.balanceOf(address(this));
        assertGt(finalBalance, initialBalance);
    }
}
