// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract AdDivide {
    string public Name; // Added public visibility
    uint256 public AddNumber; // Added public visibility
    uint256 public DivNumber; // Added public visibility

    // Function to save the name
    function saveName(string memory _name) public {
        Name = _name;
    }

    // Function to perform addition
    function add(uint256 num1, uint256 num2) public returns (uint256) {
        AddNumber = num1 + num2;
        return AddNumber;
    }

    // Function to return the stored AddNumber
    function getAddNumber() public view returns (uint256) {
        return AddNumber;
    }

    // Function to perform division
    function divide(uint256 num1, uint256 num2) public returns (uint256) {
        require(num2 != 0, "num2 cannot be zero"); // Added semicolon
        DivNumber = num1 / num2;
        return DivNumber;
    }
}
