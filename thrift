// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ThriftContract {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        if (amount <= address(this).balance) {
            payable(msg.sender).transfer(amount);
            balances[msg.sender] -= amount;
            emit Withdrawal(msg.sender, amount);
        } else {
            revert("Contract balance is insufficient");
        }
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
