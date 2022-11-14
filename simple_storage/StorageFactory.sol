// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {

    // public name of the SimpleStorage contract 
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // Create a new memory contract, so that it can be pushed into simpleStorageArray
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    // StorageFactoryStore
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // In order to interact with a contract, you will ALWAYS need two things: 
        // - Address
        // - ABI - Application Binary Interface

        // Instead of creating a new SimpleStorage object, we copy the SimpleStorage instance at _simpleStorageIndex to our local object 
        // This allows to retrieve both Address and ABI of the contract specified
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];

        // Store in the Local Storage the "favorite" number 
        simpleStorage.store(_simpleStorageNumber);
    }

    // StorageFactoryGet
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }

}