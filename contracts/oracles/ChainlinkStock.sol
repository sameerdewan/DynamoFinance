// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../../node_modules/@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "../data/BetsDataInterface.sol";
import "../DynamoFinanceInterface.sol";

contract ChainlinkStock is ChainlinkClient {
    BetsDataInterface BetsData;
    DynamoFinanceInterface DynamoFinance;
    uint256 oraclePayment;
    struct Fulfillment {
        bool exists;
        uint256 price;
    }
    mapping(bytes32 => Fulfillment) fulfillments;
    constructor(uint256 _oraclePayment, address dynamoFinance) public {
        setPublicChainlinkToken();
        oraclePayment = _oraclePayment;
        DynamoFinance = DynamoFinanceInterface(dynamoFinance);
    }
    modifier isSafe() {
        require(DynamoFinance.safeCallFn(msg.sender) == true, 'ERROR: UNSAFE');
        _;
    }
    function priceRequest(address oracle, bytes32 jobId, string calldata field, string calldata ticker, uint256 dateOfExecution) external isSafe() returns(bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.addUint('until', dateOfExecution);
        req.add('field', field);
        req.add('ticker', ticker);
        req.addInt('times', 100);
        requestId = sendChainlinkRequestTo(oracle, req, oraclePayment);
    }
    function cancelRequest(bytes32 requestId) public isSafe() {
        cancelChainlinkRequest(requestId, oraclePayment, this.fulfill.selector, now);
    }
    function fulfill(bytes32 requestId, uint256 price) public recordChainlinkFulfillment(requestId) {
        fulfillments[requestId] = Fulfillment({ exists: true, price: price });
        BetsData.fulfill(requestId, price);
    }
    function getFulfillment(bytes32 requestId) public view isSafe() returns (uint256 price) {
        require(fulfillments[requestId].exists == true, 'ERROR: NOT FOUND');
        price = fulfillments[requestId].price;
    }
}
