// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface TiingoChainlinkInterface {
     function request(string calldata field, string calldata ticker, uint256 until) external returns(bytes32 requestId);
}
