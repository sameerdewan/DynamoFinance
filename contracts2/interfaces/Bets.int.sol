// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface BetsInterface {
    function payout(bytes32 requestId, uint256 price) external;
}
