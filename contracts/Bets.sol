// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./DynamoFinanceInterface.sol";
import "./data/BetsDataInterface.sol";

contract Bets {
    DynamoFinanceInterface DynamoFinance;
    BetsDataInterface BetsData;
    constructor(address dynamoFinance, address betsData) public {
        DynamoFinance = DynamoFinanceInterface(dynamoFinance);
        BetsData = BetsDataInterface(betsData);
    }
    function createBet(uint256 timeUntilExecute, uint256 timeToParticipate, string calldata ticker, bytes32 id) public payable {
        BetsData.persistBetData(now + timeUntilExecute, now + timeToParticipate, ticker, id, msg.value);
    }
    function participateInBet(string calldata ticker, bytes32 id) public payable {
        BetsData.persistParticipationData(ticker, id, msg.value);
    }
}