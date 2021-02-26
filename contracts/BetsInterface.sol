// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface BetsInterface {
    function payout(string calldata ticker, bytes32 id) external returns(bool);
}