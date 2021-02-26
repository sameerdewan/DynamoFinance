// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import './base/DynamoContract.sol';
import './interfaces/DynamoFinance.int.sol';
import './interfaces/TiingoChainlink.int.sol';

contract BetsContract is DynamoContract {
    DynamoFinanceInterface DynamoFinance;
    TiingoChainlinkInterface TiingoChainlink;

    struct BetContract {
        bytes32 requestId;
        uint256 value;
        uint256 until;
        uint256 untilParticipation;
        uint256 bets;
        uint256 poolValue;
        bool exists;
        bool payedOut;
        string field;
        string ticker;
        address creator;
    }
    struct Bet {
        bytes32 requestId;
        bytes32 betId;
        uint256 prediction;
        address predictor;
    }
    mapping(bytes32 => BetContract) public dynamoBetContractMap;
    BetContract[] public dynamoBetContractArray;
    uint256 numberOfBetContracts = 0;
    mapping(bytes32 => Bet[]) public dynamoBetsMap;
    mapping(bytes32 => Bet) public dynamoBetMap;

    constructor(address contract_main) public {
        DynamoFinance = DynamoFinanceInterface(contract_main);
    }

    function setContract(string calldata contractKey, address _address) external returns(bool success) {
        success = false;
        DynamoFinance.safeCallFn(address(this));
        if (compare(contractKey, main) == true) {
            DynamoFinance = DynamoFinanceInterface(_address);
            success = true;
        }
        else if (compare(contractKey, oracle) == true) {
            TiingoChainlink = TiingoChainlinkInterface(_address);
        }
        else if (compare(contractKey, events) == true) {

        }
    }

    function createBet(uint256 millisecondsTillEnd, uint256 millisecondsToParticipate, string calldata ticker, string calldata field, uint256 prediction) external payable returns(bytes32 requestId, bytes32 betId) {
        uint256 msToSecondsTillEnd = millisecondsTillEnd * 1000;
        uint256 until = now + msToSecondsTillEnd;
        uint256 msToSecondsToParticipate = millisecondsToParticipate * 1000;
        uint256 untilParticipation = now + msToSecondsToParticipate;
        requestId = TiingoChainlink.request(field, ticker, until);
        BetContract memory DynamoBetContract = BetContract({
            requestId: requestId,
            value: msg.value,
            until: until,
            untilParticipation: untilParticipation,
            bets: 1,
            poolValue: msg.value,
            exists: true,
            payedOut: false,
            field: field,
            ticker: ticker,
            creator: msg.sender
        });
        dynamoBetContractMap[requestId] = DynamoBetContract;
        numberOfBetContracts += 1;
        dynamoBetContractArray.push(DynamoBetContract);
        betId = keccak256(abi.encodePacked(requestId, prediction, msg.sender));
        Bet memory DynamoBet = Bet({
            requestId: requestId,
            betId: betId,
            prediction: prediction,
            predictor: msg.sender
        });
        dynamoBetsMap[requestId].push(DynamoBet);
        dynamoBetMap[betId] = DynamoBet;
    }

    function participateInBet(bytes32 requestId, uint256 prediction) external payable returns(bytes32 betId) {
        require(dynamoBetContractMap[requestId].exists == true, 'ERROR: Bets@participateInBet()::nonexistent');
        require(msg.value >= dynamoBetContractMap[requestId].value, 'ERROR: Bets@participateInBet()::value');
        require(dynamoBetContractMap[requestId].until < now, 'ERROR: Bets@participateInBet()::until');
        require(dynamoBetContractMap[requestId].untilParticipation < now, 'ERROR: Bets@participateInBet()::untilParticipation');
        betId = keccak256(abi.encodePacked(requestId, prediction, msg.sender));
        Bet memory DynamoBet = Bet({
            requestId: requestId,
            betId: betId,
            prediction: prediction,
            predictor: msg.sender
        });
        dynamoBetContractMap[requestId].bets += 1;
        dynamoBetContractMap[requestId].poolValue += msg.value;
        dynamoBetsMap[requestId].push(DynamoBet);
        dynamoBetMap[betId] = DynamoBet;
    }
}
