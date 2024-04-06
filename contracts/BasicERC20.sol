// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/// @title Basic ERC20 Token Contract
/// @dev This contract implements a basic ERC20 token with functionalities like transfer and balance query.

/// @title IERC20 Interface
/// @dev Interface for the ERC20 token standard, providing methods for token transfer, approval, allowance, and balance query.
interface IERC20 {
    /// @dev Transfers `value` amount of tokens from the caller's account to the recipient `to`.
    /// @param to The address of the recipient to which the tokens will be transferred.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful.
    function transfer(
        address to,
        uint256 value
    ) external returns (bool);

    /// @dev Approves `spender` to spend up to `value` tokens on behalf of the caller.
    /// @param spender The address allowed to spend the tokens.
    /// @param value The maximum amount of tokens that can be spent.
    /// @return A boolean indicating whether the approval was successful.
    function approve(
        address spender,
        uint256 value
    ) external returns (bool);

    /// @dev Transfers `value` amount of tokens from the `from` address to the `to` address using the allowance mechanism.
    /// @param from The address from which the tokens will be transferred.
    /// @param to The address to which the tokens will be transferred.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful.
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    /// @dev Returns the balance of the specified `account`.
    /// @param account The address of the account to query the balance of.
    /// @return The balance of the specified account.
    function balanceOf(address account) external view returns (uint256);

    /// @dev Returns the amount of tokens that `spender` is allowed to spend on behalf of `owner`.
    /// @param owner The address of the token owner.
    /// @param spender The address of the spender.
    /// @return The amount of tokens that `spender` is allowed to spend on behalf of `owner`.
    function allowance(address owner, address spender) external view returns (uint256);
    
    /// @dev Sets or unsets approval for the operator to spend all tokens from the caller's account.
    /// @param operator The address of the operator for which to set the approval.
    /// @param approved A boolean indicating whether to approve or revoke the operator's ability to spend all tokens from the caller's account.
    /// @return A boolean indicating whether the operation was successful.
    function setApprovalForAll(address operator, bool approved) external returns (bool);
}

contract BWCContract {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private TotalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /// @dev Emitted when tokens are transferred from one account to another.
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    /// @dev Emitted when the allowance of a spender for an owner is set by the owner.
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /// @dev Emitted when the approval of an operator to spend all tokens from the caller's account is set or unset.
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /// @dev Emitted when tokens are minted to `to`.
    event Mint(address indexed to, uint256 amount);

    /// @dev Emitted when an address is provided as zero.
    error ZeroAddress(address addr, string message);

    /// @dev Emitted when an account has insufficient balance.
    error InsufficientBalance(
        address account,
        uint256 required,
        uint256 available
    );

    /// @dev Emitted when a zero value is encountered.
    error ZeroValue();

    /// @dev Constructs the contract, initializing the name, symbol, and decimals of the token.
    /// @param name_ The name of the token.
    /// @param symbol_ The symbol of the token.
    /// @param decimals_ The number of decimals used in the token.
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /// @dev Returns the name of the token.
    /// @return The name of the token.
    function name() public view returns (string memory) {
        return _name;
    }

    /// @dev Returns the symbol of the token.
    /// @return The symbol of the token.
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /// @dev Returns the number of decimals used in the token.
    /// @return The number of decimals used in the token.
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /// @dev Returns the total supply of the token.
    /// @return The total supply of the token.
    function totalSupply() public view returns (uint256) {
        return TotalSupply;
    }

    /// @dev Returns the balance of the specified account.
    /// @param account The address of the account to query the balance of.
    function balanceOf(address account) public view returns (uint256 balance) {
        balance = _balances[account];
    }

    /// @dev Returns the allowance of one address to another.
    /// @param owner The address which owns the funds.
    /// @param spender The address which will spend the funds.
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    /// @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    /// @param spender The address which will spend the funds.
    /// @param amount The amount of tokens to allow.
    /// @return A boolean value indicating whether the operation succeeded.
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /// @dev Sets or unsets approval for the operator to spend all tokens from the caller's account.
    /// @param operator The address of the operator for which to set the approval.
    /// @param approved A boolean indicating whether to approve or revoke the operator's ability to spend all tokens from the caller's account.
    /// @return A boolean indicating whether the operation was successful.
    function setApprovalForAll(address operator, bool approved) external returns (bool) {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
        return true;
    }

    /// @dev Transfers tokens from the sender's account to the specified recipient.
    /// @param to The address of the recipient.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful.
    function transfer(address to, uint256 value) public returns (bool) {
        address from = msg.sender;

        if (from == address(0)) {
            revert ZeroAddress(from, "Sender is zero address");
        }

        if (to == address(0)) {
            revert ZeroAddress(to, "Receiver is zero address");
        }
        if (value == 0) {
            revert ZeroValue();
        }

        uint256 fromBalance = _balances[from];

        if (fromBalance < value) {
            revert InsufficientBalance(
                from,
                value,
                fromBalance
            );
        }

        _balances[from] -= value;
        _balances[to] += value;

        emit Transfer(from, to, value);
        return true;
    }

    /// @dev Transfers tokens from one address to another using the allowance mechanism.
    /// @param from The address from which the tokens will be transferred.
    /// @param to The address to which the tokens will be transferred.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful.
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        address spender = msg.sender;

        if (from == address(0)) {
            revert ZeroAddress(from, "Sender is zero address");
        }

        if (to == address(0)) {
            revert ZeroAddress(to, "Receiver is zero address");
        }

        uint256 spenderAllowance = _allowances[from][spender];
        if (!_operatorApprovals[from][spender] && value > spenderAllowance) {
            revert InsufficientBalance(
                spender,
                value,
                spenderAllowance
            );
        }

        uint256 fromBalance = _balances[from];
        if (fromBalance < value) {
            revert InsufficientBalance(
                from,
                value,
                fromBalance
            );
        }

        _balances[from] -= value;
        _balances[to] += value;
        if (!_operatorApprovals[from][spender]) {
            _allowances[from][spender] -= value;
        }

        emit Transfer(from, to, value);
        return true;
    }

    /// @dev Mints new tokens and adds them to the specified account.
    /// @param to The address of the account to receive the minted tokens.
    /// @param value The amount of tokens to mint.
    function mint(address to, uint256 value) public {
        address from = msg.sender;
        if (from == address(0)) {
            revert ZeroAddress(from, "Sender is zero address");
        }
        if (to == address(0)) {
            revert ZeroAddress(to, "Receiver is zero address");
        }
        if (value == 0) {
            revert ZeroValue();
        }

        TotalSupply += value;
        _balances[to] += value;

        emit Mint(to, value);
    }
}




// ASSIGNMENT (30/03/2024)
// 1. Convert all require statements to custom errors (https://docs.soliditylang.org/en/v0.8.25/contracts.html#errors-and-the-revert-statement)
// 2. Document the code using NatSpec format (https://docs.soliditylang.org/en/v0.8.25/natspec-format.html)
// 3. Add events to contract as required by the token standard specified here: https://eips.ethereum.org/EIPS/eip-20
// 4. After 1, 2, and 3 have been completed, deploy your token to Sepolia testnet using either Remix IDE or Hardhat 
//    and send contract address to #assignment channel on discord. Example token contract address on Sepolia: https://sepolia.etherscan.io/token/0x7ce4DacfD778cAac416899F31638F9abbC072AAE