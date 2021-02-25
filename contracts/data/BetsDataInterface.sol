// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface BetsDataInterface {
    function persistBetData(uint256 timeUntilExecute, uint256 timeToParticipate, string calldata ticker, bytes32 id, uint value) external returns(bool);
    function persistParticipationData(string calldata ticker, bytes32 id, uint value) external returns(bool);
    function persistBetCancelation(string calldata ticker, bytes32 id, address _address) external returns(bool);
    function getBet(string calldata ticker, bytes32 id) external returns(bool, bool, address payable, uint);
    function payoutBet(string calldata ticker, bytes32 id) external;
}
