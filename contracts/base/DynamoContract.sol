// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import '../interfaces/DynamoFinance.int.sol';

contract DynamoContract {
    string constant main = 'contract_main';
    string constant events = 'contract_events';
    string constant bets = 'contract_bets';
    string constant oracle = 'contract_oracle';

    function getContractKeys() public pure returns(string memory, string memory, string memory, string memory) {
        return (main, events, bets, oracle);
    }

    function compare(string memory a, string memory b) public pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
