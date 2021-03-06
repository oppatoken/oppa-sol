// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./SafeMath.sol";

library Transactions {
    using SafeMath for uint256;

    function _getFinalTxAmount(uint256 amount)
        internal
        pure
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 _marketingFee = amount.mul(3).div(100);
        uint256 _burnRate = amount.mul(2).div(100);
        uint256 _tmsSupportFee = amount.mul(1).div(100);

        return (
            _marketingFee,
            _burnRate,
            _tmsSupportFee,
            amount.sub(_marketingFee.add(_tmsSupportFee))
        );
    }
}
