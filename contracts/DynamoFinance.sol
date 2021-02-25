// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract DynamoFinance {
    address public owner;
    address public appAddress;
    bool public operational = false;
    mapping(address => bool) public contracts;
    mapping (address => bool) public allowed;
    constructor() public {
        owner = msg.sender;
        appAddress = address(this);
    }
    modifier onlyAllowed() {
        require(allowed[msg.sender] == true || msg.sender == owner, 'ERROR: AUTH');
        _;
    }
    function addAllowed(address _address) external onlyAllowed() {
        allowed[_address] = true;
    }
    function removeAllowed(address _address) external onlyAllowed() {
        allowed[_address] = false;
    }
    function enable() external onlyAllowed() {
        operational = true;
    }
    function disable() external onlyAllowed() {
        operational = false;
    }
    function addContract(address _address) external onlyAllowed() {
        contracts[_address] = true;
    }
    function removeContract(address _address) external onlyAllowed() {
        contracts[_address] = false;
    }
    function safeCallFn() external view returns(bool) {
        return operational == true && contracts[msg.sender] == true;
    }
    function isValidContract(address _address) external view returns(bool) {
        return contracts[_address] == true;
    }
    function isAllowed(address _address) external view returns(bool) {
        return allowed[_address] == true;
    }
}
