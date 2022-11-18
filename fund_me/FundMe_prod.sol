// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";

// Constant & Immutable
// Let us save a lot of gas when deploying
//
// If a variable is CONSTANT, that means that it takes a 
// value when contract is compiled and never changes
//
//
// If a variable is IMMUTABLE, that means that it is assigned 
// just once to a value but not when it is declared


// Using custom errors instead of custom require messages is going to 
// lets save a lot of gas previously used for storing revert error 
// messages like "Sender is not owner!"   
error NotOwner();

// If someone sends this contract some ETH without calling fund() function
// then receive()/fallback() function will be triggered automatically
// A contract can have at most one receive function, declared using 
// receive() external payable {...} (without the function keyword, cannot return anything and must be external)
// While receive() manages tx with non specified function called, fallback() handles tx with non specified functions
// called as well but with some params passed 
// fallback() canis executed on a call to the contract if none of the other functions match
// the given signature, or if no data was supplied at all and there is no receive() Ether function.
// it handles parameters, but if it has to receive also eth then it has to be payable

contract FundMe {

    using PriceConverter for uint256;

    // Impact of keyword 'constant' when calling view function MINIMUM_USD
    // using constant           - 21,415 gas
    // without using constant   - 23,515 gas
    // Best Pratice: UPPERCASE name
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    // using immutable          - 21,508 gas
    // without using immutable  - 23,644 gas
    // Best Pratice: i_ prefix
    address public immutable i_owner;


    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    modifier onlyOwner {
        // require((msg.sender == i_owner), "Sender is not owner");
        if(msg.sender != i_owner){revert NotOwner();}
        _;  
    }

    constructor (){
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Did not receive enough ETH"); // 1e18 = 1wei * 10^18 = 1 ETH
    
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }   

    function withdraw() public onlyOwner {        
        require(addressToAmountFunded[msg.sender] > 0, "Not enough funds to withdraw");

        // Reset amount of funded money for each funder, because owner is going to withdraw all the funds 
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
       
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }


    // ---------

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // ---------
}
