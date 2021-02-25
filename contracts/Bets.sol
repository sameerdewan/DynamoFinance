// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./DynamoFinanceInterface.sol";
import "./data/BetsDataInterface.sol";
import "./events/EventsInterface.sol";

contract Bets {
    DynamoFinanceInterface DynamoFinance;
    BetsDataInterface BetsData;
    EventsInterface Events;
    constructor(address dynamoFinance, address betsData) public {
        DynamoFinance = DynamoFinanceInterface(dynamoFinance);
        BetsData = BetsDataInterface(betsData);
        Events = EventsInterface(DynamoFinance.getEventsAddress());
    }
    function createBet(uint256 timeUntilExecute, uint256 timeToParticipate, string calldata ticker, bytes32 id) public payable {
        bool success = BetsData.persistBetData(now + timeUntilExecute, now + timeToParticipate, ticker, id, msg.value);
        if (success == true) {

        }
    }
    function participateInBet(string calldata ticker, bytes32 id) public payable {
        BetsData.persistParticipationData(ticker, id, msg.value);
    }
}