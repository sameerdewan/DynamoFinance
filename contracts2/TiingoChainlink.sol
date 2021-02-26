// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import '../node_modules/@chainlink/contracts/src/v0.6/ChainlinkClient.sol';
import './base/DynamoContract.sol';
import './interfaces/DynamoFinance.int.sol';
import './interfaces/Bets.int.sol';

contract TiingoChainlinkContract is ChainlinkClient, DynamoContract {
    DynamoFinanceInterface DynamoFinance;
    BetsInterface Bets;

    uint256 public oraclePayment = 1;
    struct Fulfillment {
        bool exists;
        bool fulfilled;
        uint256 price;
        string field;
        string ticker;
        uint256 until;
    }
    mapping(bytes32 => Fulfillment) fulfillments;
    address public oracleServiceProvider;
    bytes32 public oracleJobId;

    constructor(address contract_main) public {
        setPublicChainlinkToken();
        DynamoFinance = DynamoFinanceInterface(contract_main);
    }

    function setContract(string calldata contractKey, address _address) external returns(bool success) {
        success = false;
        DynamoFinance.safeCallFn(msg.sender);
        if (compare(contractKey, main) == true) {
            DynamoFinance = DynamoFinanceInterface(_address);
            success = true;
        }
        else if (compare(contractKey, bets) == true) {
            Bets = BetsInterface(_address);
        }
        else if (compare(contractKey, events) == true) {

        }
    }

    function setOracleData(string calldata field, address _address) external returns(bool success) {
        success = false;
        DynamoFinance.safeCallFn(msg.sender);
        if (compare(field, 'oracleServiceProvider') == true) {
            oracleServiceProvider = _address;
            success = true;
        }
        require(success == true, 'ERROR: TiingoChainlink@setOracleData::oracleServiceProvider');
    }

    function setOracleData(string calldata field, bytes32 provider) external returns(bool success) {
        success = false;
        DynamoFinance.safeCallFn(msg.sender);
        if (compare(field, 'oracleJobId') == true) {
            oracleJobId = provider;
            success = true;
        }
        require(success == true, 'ERROR: TiingoChainlink@setOracleData::oracleJobId');
    }

    function setOracleData(string calldata field, uint256 payment) external returns(bool success) {
        success = false;
        DynamoFinance.safeCallFn(msg.sender);
        if (compare(field, 'oraclePayment') == true) {
            oraclePayment = payment;
            success = true;
        }
        require(success == true, 'ERROR: TiingoChainlink@setOracleData::oraclePayment');
    }
    
    function request(string calldata field, string calldata ticker, uint256 until) external returns(bytes32 requestId) {
        DynamoFinance.safeCallFn(msg.sender);
        require(DynamoFinance.getContract(bets) == msg.sender, 'ERROR: TiingoChainlink@request::notBets');
        Chainlink.Request memory req = buildChainlinkRequest(oracleJobId, address(this), this.fulfill.selector);
        req.addUint('until', until);
        req.add('field', field);
        req.add('ticker', ticker);
        req.addInt('times', 100);
        requestId = sendChainlinkRequestTo(oracleServiceProvider, req, oraclePayment);
        fulfillments[requestId] = Fulfillment({
            exists: true,
            fulfilled: false,
            price: 0,
            field: field,
            ticker: ticker,
            until: until
        });
    }

    function cancelRequest(bytes32 requestId) external {
        DynamoFinance.safeCallFn(msg.sender);
        cancelChainlinkRequest(requestId, oraclePayment, this.fulfill.selector, now);
    }

    function getRequest(bytes32 requestId) external view returns(bool exists, bool fulfilled, uint256 price, string memory field, string memory ticker, uint256 until) {
        require(fulfillments[requestId].exists == true, 'ERROR: TiingoChainlink@getRequest::nonexistent');
        exists = fulfillments[requestId].exists;
        fulfilled = fulfillments[requestId].fulfilled;
        price = fulfillments[requestId].price;
        field = fulfillments[requestId].field;
        ticker = fulfillments[requestId].ticker;
        until = fulfillments[requestId].until;
    }

    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId) {
        require(fulfillments[_requestId].exists == true && fulfillments[_requestId].fulfilled == false, 'ERROR: TiingoChainlink@fulfill');
        fulfillments[_requestId].fulfilled = true;
        fulfillments[_requestId].price = _price;
        Bets.payout(_requestId, _price);
    }
}
