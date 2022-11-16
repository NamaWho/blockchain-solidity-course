// SPDX-License-Identifier: MIT
// This old version is because nowadays it wouldn't compile because of the reasons explained in the contract
// pragma solidity ^0.6.0;
// We can using newer versions if us the "unchecked" keyword
pragma solidity ^0.8.0;



// SafeMath library tester
// No longer used due to bug reveiled
contract SafeMathTester {

    // this variable is "unchecked", which means that if it gets over its upper bound, it wraps around and restarts from its lower bound
    uint8 public bigNumber = 255;
    
    // this function would set bigNumber to 0, due to variable size (8 bit)
    function add() public {
        unchecked {
          bigNumber = bigNumber + 1;   
        }
    }

}