// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./OppaTwo.sol";

import "hardhat/console.sol";

contract Factory {
    OppaTwo public token;

    constructor() public payable {
        token = new OppaTwo();
        console.log("TOKEN: ", address(token));

        IPancakeRouter02 _pancakeV2Router = IPancakeRouter02(
            0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
        );

        token.approve(address(_pancakeV2Router), token.balanceOf(address(1)));

        (, , uint256 liquidity) = _pancakeV2Router.addLiquidityETH{
            value: 200000000000
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
