// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface BetsDataInterface {
    function persistBetData(uint256 timeUntilExecute, uint256 timeToParticipate, string calldata ticker, bytes32 id, uint value) external;
    function persistParticipationData(string calldata ticker, bytes32 id, uint value) external 
}
