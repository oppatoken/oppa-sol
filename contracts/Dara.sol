// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// interfaces
import "./interface/IBEP20.sol";
import "./interface/IPancakeRouter02.sol";
import "./interface/IPancakeFactory.sol";

// utilities
import "./utils/Context.sol";
import "./utils/Ownable.sol";

// libraries
import "./library/Iterable.sol";
import "./library/SafeMath.sol";
import "./library/Transactions.sol";
import "./library/Rewards.sol";

// development
import "hardhat/console.sol";

contract Dara is Context, IBEP20, Ownable {
    using IterableMapping for IterableMapping.Map;
    using SafeMath for uint256;
    using Transactions for Transactions;
    using Rewards for Rewards;

    IterableMapping.Map _balances;
    IterableMapping.Map _pairs;
    IterableMapping.Map _rewardees;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 private _reflectedBalances;

    uint256 private INCLUDED = 777;

    uint8 private _decimals;

    string private _symbol;
    string private _name;

    bool private taxEnabled = false;

    address _marketing = 0xE11BA2b4D45Eaed5996Cd0823791E0C93114882d;
    address _development = 0xd03ea8624C8C5987235048901fB614fDcA89b117;
    address _liquidityAddress = 0x22d491Bde2303f2f43325b2108D26f1eAbA1e32b;

    address public _pancakePair;

    IPancakeRouter02 _pancakeV2Router;

    constructor() public {
        _name = "Sandara Park";
        _symbol = "DARA";
        _decimals = 18;
        _totalSupply = 100000000000000000 * 10**18; // 100 Quadrillion
        _balances.set(msg.sender, _totalSupply);

        _pancakeV2Router = IPancakeRouter02(
            0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        );

        _pairs.set(
            IPancakeFactory(_pancakeV2Router.factory()).createPair(
                address(this),
                _pancakeV2Router.WETH()
            ),
            INCLUDED
        );

        _pancakePair = _pairs.getKeyAtIndex(0);

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
        return
            _balances.get(account) +
            Rewards._calculateRewards(_rewardees.size(), _reflectedBalances);
    }

    /**
     * @dev Rewards.
     */
    function rewardsPool() external view returns (uint256) {
        return _reflectedBalances;
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
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (
            (_pairs.get(sender) == INCLUDED ||
                _pairs.get(recipient) == INCLUDED) &&
            taxEnabled &&
            sender != _liquidityAddress &&
            sender != owner() &&
            _marketing != sender &&
            _development != sender
        ) {
            if (sender != owner()) {
                require(amount <= _maxTxAmount(), "OPPA: anti-dump engaged");
                require(
                    _balances.get(recipient).add(amount) <= _maxTxAmount(),
                    "OPPA: anti-whale engaged"
                );
            }

            if (_pairs.get(sender) == INCLUDED) {
                _handleBuyTax(sender, recipient, amount);
            }

            if (_pairs.get(recipient) == INCLUDED) {
                _handleSellTax(sender, recipient, amount);
            }
            return;
        }

        if (sender == _liquidityAddress)
            require(
                _pairs.get(recipient) == INCLUDED,
                "Dara: transfer to non-pancakePair"
            );

        _balances.set(sender, _balances.get(sender).sub(amount));
        _balances.set(recipient, _balances.get(recipient).add(amount));

        emit Transfer(sender, recipient, amount);
    }

    /**
    @dev 
    handle buy tax
     */
    function _handleBuyTax(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        _balances.set(sender, _balances.get(sender).sub(amount));
        (
            uint256 _marketingFee,
            uint256 _burnRate,
            uint256 _finalAmount
        ) = Transactions._getFinalTxAmount(amount);
        uint256 _liquidityFee = amount.mul(5).div(100);

        _balances.set(_liquidityAddress, _liquidityFee);
        _balances.set(_marketing, _marketingFee);

        uint256 initialRecipientBalance = _balances.get(recipient);
        _balances.set(
            recipient,
            initialRecipientBalance.add(_finalAmount).sub(_liquidityFee)
        );
        _burn(recipient, _burnRate);
        addRewardee(recipient);
    }

    function _handleSellTax(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        _balances.set(sender, _balances.get(sender).sub(amount));
        (
            uint256 _marketingFee,
            uint256 _burnRate,
            uint256 _finalAmount
        ) = Transactions._getFinalTxAmount(amount);

        _balances.set(_development, _marketingFee);

        uint256 _reflectFee = amount.mul(9).div(100);
        uint256 initialRecipientBalance = _balances.get(recipient);
        _balances.set(
            recipient,
            initialRecipientBalance.add(_finalAmount).sub(_reflectFee)
        );
        _burn(recipient, _burnRate);
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

    function addRewardee(address _rewardee) internal {
        if (_pairs.get(_rewardee) == INCLUDED) {
            if (_balances.get(_rewardee) < 1) {
                _rewardees.remove(_rewardee);
                return;
            }

            _rewardees.set(_rewardee, 0);
        }
    }

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

    function setTaxationStatus() external returns (bool) {
        taxEnabled = !taxEnabled;
        return taxEnabled;
    }

    function burn(uint256 amount) public virtual onlyOwner {
        _burn(msg.sender, amount);
    }

    function _maxTxAmount() internal view returns (uint256) {
        return _totalSupply.mul(2).div(100);
    }
}
