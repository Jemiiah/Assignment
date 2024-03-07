// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract AdDivide {
    string public name; // Added public visibility
    uint256 public addnumber; // Added public visibility
    uint256 public divnumber; // Added public visibility

    // Function to save the name
    function saveName(string memory _name) public {
        name = _name;
    }

    // Function to perform addition
    function add(uint256 num1, uint256 num2) public returns (uint256) {
        addnumber = num1 + num2;
        return addnumber;
    }

    // Function to return the stored AddNumber
    function getAddNumber() public view returns (uint256) {
        return addnumber;
    }

    // Function to perform division
    function divide(uint256 num1, uint256 num2) public returns (uint256) {
        require(num2 != 0, "num2 cannot be zero"); // Added semicolon
        divnumber = num1 / num2;
        return divnumber;
    }
    function divide() public view returns(uint256) {
        return divnumber;
    }
}
