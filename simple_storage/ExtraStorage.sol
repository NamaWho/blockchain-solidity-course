//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// We'd like to have our ExtraStorage contract with functionalities of SimpleStorage
// Inheritance is used for this
import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {

    // We'd like to add 5 to each number given, differently from SimpleStorage
    // Override comes to our mind
    // Virtual override (in order to let a function be overrided, it has to be "virtual")
    function store(uint256 _favoriteNumber) public override{
        favoriteNumber = _favoriteNumber + 5;
    }

}