// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import './base/DynamoContract.sol';
import './TiingoChainlink.sol';

contract DynamoFinance is DynamoContract {

    address public owner;
    address public contract_main;
    address public contract_events;
    address public contract_bets;
    address public contract_oracle;

    mapping(address => bool) allowed;

    bool public operational = false;

    constructor(bool newEvents, bool newBets, bool newOracle) public {
        owner = msg.sender;
        contract_main = address(this);
        if (newEvents == true) {

        }
        if (newBets == true) {

        }
        if (newOracle == true) {
            contract_oracle = address(new TiingoChainlinkContract(contract_main));
            allowed[contract_oracle] = true;
        }
    }

    modifier onlyAllowed() {
        require(msg.sender == owner || allowed[msg.sender] == true, 'ERROR: DynamoFinance@onlyAllowed()');
        _;
    }

    function setContract(string calldata contractKey, address _address) external onlyAllowed() returns(bool success) {
        success = false;
        if (compare(contractKey, events) == true) {
            allowed[contract_events] = false;
            contract_events = _address;
            success = true;
        }
        else if (compare(contractKey, bets) == true) {
            allowed[contract_events] = false;
            contract_bets = _address;
            success = true;
        }
        else if (compare(contractKey, oracle) == true) {
            allowed[contract_events] = false;
            contract_oracle = _address;
            success = true;
        }
        if (success == true) {
            allowed[_address] = true;
        }
    }

    function setPermissions(address _address, bool permission) external onlyAllowed() {
        allowed[_address] = permission;
    }

    function setOperational(bool state) external onlyAllowed() {
        operational = state;
    }

    function getContract(string calldata contractKey) external view returns(address _address) {
        bool success = false;
        if (compare(contractKey, main) == true) {
            _address = contract_main;
            success = true;
        }
        else if (compare(contractKey, events) == true) {
            _address = contract_events;
            success = true;
        }
        else if (compare(contractKey, bets) == true) {
            _address = contract_bets;
            success = true;
        }
        else if (compare(contractKey, oracle) == true) {
            _address = contract_oracle;
            success = true;
        }
        require(success == true, 'ERROR: DynamoFinance@getContract()');
    }

    function safeCallFn(address _address) external view {
        require(operational == true && allowed[_address] == true, 'ERROR: DynamoFinance@safeCallFn');
    }
}
