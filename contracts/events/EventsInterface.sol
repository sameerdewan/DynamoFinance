// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface EventsInterface {
    function fireEvent_ContractToggle(bool operational) external;
    function fireEvent_ContractPermissions(address _address, bool allowed) external;
    function fireEvent_BetCreated(uint256 dateOfExecution, string calldata ticker, bytes32 id, uint value) external;
    function fireEvent_BetParticipation(string calldata ticker, bytes32 id, uint value) external;
}