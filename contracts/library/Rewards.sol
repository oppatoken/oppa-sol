// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./SafeMath.sol";

library Rewards {
    using SafeMath for uint256;

    function _calculateRewards(uint256 _rewardsSize, uint256 _reflectedBalances)
        internal
        pure
        returns (uint256)
    {
        if (_rewardsSize != 0) {
            uint256 reward = _reflectedBalances.div(_rewardsSize);
            return reward;
        }

        return 0;
    }
}
