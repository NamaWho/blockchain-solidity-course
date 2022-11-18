// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Ether is sent to contract
//              is msg.data empty?
//                  /       \
//                 yes      no
//                /           \
//            receive()?    fallback()
//             /    \
//            yes   no
//           /        \
//       receive()  fallback()

contract FallbackExample {
    uint256 public result;

    // whenever ETH are sent to the contract, this special function will be triggered
    // anytime we send a tx without specifying any function, then it triggers (0 wei tx as well)
    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}