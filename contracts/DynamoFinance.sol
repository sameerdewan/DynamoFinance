// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract DynamoFinance {
    address public owner;
    address public appAddress;
    bool public operational = false;
    mapping(address => bool) public contracts;
    constructor() public {
        owner = msg.sender;
        appAddress = address(this);
    }
    function isValidContract(address _address) external view returns(bool) {
        return contracts[_address] == true;
    }
}
