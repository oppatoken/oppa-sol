// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./Jungkook.sol";

import "hardhat/console.sol";

contract Factory {
    Jungkook public token;
    address routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;

    constructor() public {
        token = Jungkook(0xAa6b1B53D078C8c573ADD945b76d64FaAF25f27e);

        console.log(address(token));

        IPancakeRouter02 _pancakeV2Router = IPancakeRouter02(
            0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        );

        console.log("MESSENGER BALANCE:", token.balanceOf(msg.sender));

        token.approve(routerAddress, token.balanceOf(msg.sender));

        _pancakeV2Router.addLiquidityETH{value: 1}(
            address(token),
            20000000000000,
            20000000000000,
            1,
            msg.sender,
            block.timestamp + 99999999999
        );

        // console.log(liquidity);

        // Renounce ownership + burn liquidity here
    }
}
