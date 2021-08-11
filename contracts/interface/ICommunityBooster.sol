// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface ICommunityBooster {
    function transferCallback(
        address _from,
        address _to,
        uint256 _amount
    ) external;
}
