// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface DynamoFinanceInterface {
    function safeCallFn(address _address) external view returns(bool);
    function getEventsAddress() external view returns(address);
}
