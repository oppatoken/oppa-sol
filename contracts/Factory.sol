// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./OppaTwo.sol";

import "hardhat/console.sol";

contract Factory {
    OppaTwo public token;

    constructor() public payable {
        token = new OppaTwo();
        console.log("Adding Liquidity");

        IPancakeRouter02 _pancakeV2Router = IPancakeRouter02(
            0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        );

        (, , uint256 liquidity) = _pancakeV2Router.addLiquidityETH{
            value: msg.value
        }(
            address(token),
            token.totalSupply(),
            0,
            0,
            address(this),
            block.timestamp
        );

        console.log(liquidity);

        // Renounce ownership + burn liquidity here
    }
}
