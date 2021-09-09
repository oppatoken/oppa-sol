// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./OppaTwo.sol";

import "hardhat/console.sol";

contract Factory {
    OppaTwo public token;

    constructor() public {
        token = OppaTwo(0x79419dC8c39d9ECa79025Fd2520A71b13f50E390);

        console.log(address(token));

        IPancakeRouter02 _pancakeV2Router = IPancakeRouter02(
            0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        );

        token.approve(address(_pancakeV2Router), token.balanceOf(msg.sender));

        _pancakeV2Router.addLiquidityETH{value: 1000000000000000000000}(
            address(token),
            100000000000000000000000000000,
            100000000000000000000000000000,
            10000000000000000,
            msg.sender,
            block.timestamp + 999999999999
        );

        // console.log(liquidity);

        // Renounce ownership + burn liquidity here
    }
}
