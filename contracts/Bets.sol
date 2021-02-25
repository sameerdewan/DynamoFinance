// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./DynamoFinanceInterface.sol";
import "./data/BetsDataInterface.sol";
import "./events/EventsInterface.sol";

contract Bets {
    DynamoFinanceInterface DynamoFinance;
    BetsDataInterface BetsData;
    EventsInterface Events;
    uint public funds = 0;
    constructor(address dynamoFinance, address betsData) public {
        DynamoFinance = DynamoFinanceInterface(dynamoFinance);
        BetsData = BetsDataInterface(betsData);
        Events = EventsInterface(DynamoFinance.getEventsAddress());
    }
    function createBet(uint256 timeUntilExecute, uint256 timeToParticipate, string calldata ticker, bytes32 id) public payable returns(bool success) {
        success = BetsData.persistBetData(now + timeUntilExecute, now + timeToParticipate, ticker, id, msg.value);
        if (success == true) {
            funds += msg.value;
            Events.fireEvent_BetCreated(now + timeUntilExecute, now + timeToParticipate, ticker, id, msg.value);
        }
    }
    function participateInBet(string calldata ticker, bytes32 id) public payable returns(bool success) {
        success = BetsData.persistParticipationData(ticker, id, msg.value);
        if (success == true) {
            funds += msg.value;
            Events.fireEvent_BetParticipation(ticker, id, msg.value);
        }
    }
    function cancelBet(string calldata ticker, bytes32 id) public returns(bool success) {
        success = BetsData.persistBetCancelation(ticker, id, msg.sender);
        if (success == true) {
            Events.fireEvent_BetCancelled(ticker, id);
        }
    }
    function payout(string calldata ticker, bytes32 id) external returns(bool success) {
        success = false;
        (bool payedOut, bool ended, address payable winner, uint value) = BetsData.getBet(ticker, id);
        if (payedOut == false && ended == true) {
            BetsData.payoutBet(ticker, id);
            winner.transfer(value);
            success = true;
        }
    }
}