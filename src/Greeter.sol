// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Greeter {
    string public greeting;
    address public owner;

    constructor(string memory _greeting, address _owner) {
        greeting = _greeting;
        owner = _owner;
    }

    function greet(string memory name) public view returns (string memory) {
        return string.concat(greeting, ", ", name, "!");
    }

    function setGreeting(string memory _greeting) external {
        greeting = _greeting;
    }
}
