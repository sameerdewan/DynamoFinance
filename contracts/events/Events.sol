// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../DynamoFinanceInterface.sol";

contract EventsContract {
    DynamoFinanceInterface DynamoFinance;
    event event_ContractToggle(bool operational);
    event event_ContractPermissions(address _address, bool allowed);
    event event_BetCreated(uint256 dateOfExecution, uint256 timeToParticipate, string ticker, bytes32 id, uint value);
    event event_BetParticipation(string ticker, bytes32 id, uint value);
    constructor(address dynamoFinance) public {
        DynamoFinance = DynamoFinanceInterface(dynamoFinance);
    }
    modifier isSafe() {
        require(DynamoFinance.safeCallFn(msg.sender) == true, 'ERROR: UNSAFE');
        _;
    }
    function fireEvent_ContractToggle(bool operational) external isSafe() {
        emit event_ContractToggle(operational);
    }
    function fireEvent_ContractPermissions(address _address, bool allowed) external isSafe() {
        emit event_ContractPermissions(_address, allowed);
    }
    function fireEvent_BetCreated(uint256 dateOfExecution, uint256 timeToParticipate, string calldata ticker, bytes32 id, uint value) external isSafe() {
        emit event_BetCreated(dateOfExecution, timeToParticipate, ticker, id, value);
    }
    function fireEvent_BetParticipation(string calldata ticker, bytes32 id, uint value) external isSafe() {
        emit event_BetParticipation(ticker, id, value);
    }
}
