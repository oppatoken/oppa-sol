// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./utils/Context.sol";
import "./utils/Ownable.sol";

import "./interface/IPancakeRouter02.sol";
import "./interface/IPancakeFactory.sol";

import "./library/BEP20.sol";
import "./library/SafeMath.sol";
import "./library/Address.sol";
import "./library/Iterable.sol";

import "hardhat/console.sol";

contract OppaTwo is Context, IBEP20, Ownable {
    using IterableMapping for IterableMapping.Map;
    IterableMapping.Map private _rewardees;

    using SafeMath for uint256;
    IterableMapping.Map private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;

    uint256 _reflectedBalances;

    string private _symbol;
    string private _name;

    address marketing = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address development = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    IPancakeRouter02 public pancakeRouter02;
    address public pancakePair;

    constructor() public {
        _name = "OppaTwo";
        _symbol = "OPPA2";
        _decimals = 18;

        _totalSupply = 1000000000000000 * 10**18;
        _balances.set(msg.sender, _totalSupply);

        IPancakeRouter02 _pancakeV2Router = IPancakeRouter02(
            0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
        );
        // Create a pancakeswap pair for this new token
        pancakePair = IPancakeFactory(_pancakeV2Router.factory()).createPair(
            address(this),
            _pancakeV2Router.WETH()
        );

        pancakeRouter02 = _pancakeV2Router;

        // _burn(msg.sender, 200000000000000 * 10**18);
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view override returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the token name.
     */
    function name() external view override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account)
        external
        view
        override
        returns (uint256)
    {
        return _balances.get(account) + calculateRewards();
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     */
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Anti Whale
     *
     */

    function _maxTxAmount() internal view returns (uint256) {
        return _totalSupply.mul(2).div(100);
    }

    /*
     *
     @dev Swap tokens for WBNB */
    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeRouter02.WETH();

        _approve(address(this), address(pancakeRouter02), tokenAmount);

        // make the swap
        pancakeRouter02.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "OPPA: transfer from the zero address");
        require(recipient != address(0), "OPPA: transfer to the zero address");
        if (sender != owner())
            require(amount <= _maxTxAmount(), "OPPA: anti-dump engaged");
        require(
            _balances.get(recipient).add(amount) <= _maxTxAmount(),
            "OPPA: anti-whale engaged"
        );

        console.log("Transferring");

        _balances.set(
            sender,
            _balances.get(sender).sub(
                amount,
                "OPPA: transfer amount exceeds balance"
            )
        );

        _balances.set(
            recipient,
            _balances.get(recipient).add(amount.mul(97).div(100))
        );

        if (sender == pancakePair || recipient == pancakePair) {
            /**
        @dev 3% Marketing fee sent to marketing address */
            _balances.set(
                marketing,
                _balances.get(marketing).add(amount.mul(3).div(100))
            );

            /**
        @dev burn 2% of transaction */
            _burn(recipient, amount.mul(2).div(100));

            // TODO: Replace here with add liquidity function
            if (sender == pancakePair) {
                _balances.set(
                    recipient,
                    _balances.get(recipient).sub(amount.mul(5).div(100))
                );
                console.log(sender == pancakePair);
                // liquify(amount.mul(5).div(100));
            }

            // TODO: replace with pancake pair clause
            if (recipient == pancakePair) {
                _balances.set(
                    recipient,
                    _balances.get(recipient).sub(amount.mul(9).div(100))
                );
                _reflectedBalances = _reflectedBalances.add(
                    amount.mul(9).div(100)
                );

                addRewardee(recipient);
            }

            return;
        }

        _balances.set(recipient, amount);

        emit Transfer(sender, recipient, amount);
    }

    /** 
    @dev test function only
    */

    function setRewardee() public {
        for (uint256 index = 4; index < 8; index++) {
            _balances.set(address(index), 8);
            addRewardee(address(index));
        }
        _reflectedBalances = 80;

        console.log(_rewardees.size());

        for (uint256 index = 4; index < 8; index++) {
            console.log(
                "Calculate Balance: ",
                _balances.get(address(index)) + calculateRewards()
            );
        }
    }

    /**
    @dev test function only
     */
    function testLiquify() public {
        addLiquidity(200000000, 100000);
    }

    /**
    
    @dev add rewardees onto the rewards pool
    -> if the rewardee has no balance
      */

    function addRewardee(address _rewardee) internal {
        if (_balances.get(_rewardee) < 1) {
            _rewardees.remove(_rewardee);
            return;
        }

        _rewardees.set(_rewardee, 0);
    }

    /**
    @dev calculate rewards based on the number of rewardees on current reward pool
     */

    function calculateRewards() private view returns (uint256) {
        if (_rewardees.size() != 0) {
            uint256 reward = _reflectedBalances.div(_rewardees.size());
            return reward;
        }

        return 0;
    }

    /**
    @dev Adds liquidity
    -> Takes the 5% of the token amount::X
    -> X is now divided into two::A & B
    -> A is now sold in exchange for WBNB::AWBNB
    -> Now B is supplied as Liquidity to the pancake pair as Token amount and the AWBNB as pair
    */

    function liquify(uint256 tokenAmount) internal {
        uint256 initialBalance = address(this).balance;
        swapTokensForEth(tokenAmount.div(2));

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to uniswap
        addLiquidity(tokenAmount.div(2), newBalance);
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) public {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(pancakeRouter02), tokenAmount);
        console.log("Adding liquidity");
        // add the liquidity
        pancakeRouter02.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances.set(account, _balances.get(account).add(amount));
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances.set(
            account,
            _balances.get(account).sub(
                amount,
                "BEP20: burn amount exceeds balance"
            )
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(
                amount,
                "BEP20: burn amount exceeds allowance"
            )
        );
    }
}
