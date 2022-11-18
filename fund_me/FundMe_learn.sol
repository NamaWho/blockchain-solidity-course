// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// -------- Chainlink TOOLS ---------

    // Chainlink Data Feeds
    // Take data from different providers and makes an weighted average, sends back a tx containing a value to the smart contract
    // Discover how it functions at https://data.chain.link
    // Providers which deliver their value earn a little commission of gas from the tx made to ChainLink

    // Chainlink VRF: Verifiable Randomness Functions
    // Blockchain is deterministic, so it's impossible to get something really random on top of it.
    // VRFs provide verifiable randomness

    // Chainlink Keepers
    // Decentralized Event-Driven execution
    // Chainlink keepers hold a registry where there are specified all the events that it has to listen to. When all of them occur, it triggers.
    // If some asset gets to a specific price...    -> do something
    // Each 10 mins...                              -> do something
    // If liquidity pool is at a dangerous level... -> do something

// ----------------------------------

// https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }

import "./PriceConverter.sol";

// Allows addresses to raise funds for themselves
// Get funds from users
// Withdraw funds
// Set a minimum funding value
contract FundMe {

    using PriceConverter for uint256;

    // uint256 public number;
    uint256 public minimumUSD = 50 * 1e18;

    address public owner;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    modifier onlyOwner {
        require((msg.sender == owner), "Sender is not owner");
        _;  // Lets continue with the normal flow of the function where the modifier is assigned to (such as withdraw())
    }

    constructor (){
        owner = msg.sender;
    }

    function fund() public payable {
        // Want to be able to set a minim funding value
        // How does the contract receive ETH?
        // Remember how a TX is composed:
        // - Nonce      > tx count for the account
        // - Gas Price  > price per unit of gas (in wei)
        // - Gas Limit  > 21000
        // - To         > address that the tx is sent to (in this case the contract address)
        // - Value      > amount of wei to send
        // - Data       > what to send to the To address
        // - v, r, s    > components of tx signature
        // In order to receive ETH, it has to be marked as 'payable'
        // To access to the ETH received, use msg.value
      
        // require(getConversionRate(msg.value) >= minimumUSD, "Did not receive enough ETH"); // 1e18 = 1wei * 10^18 = 1 ETH
        // In msg.value.getConversionRate(), msg.value is the first implicit parameter
        require(msg.value.getConversionRate() >= minimumUSD, "Did not receive enough ETH"); // 1e18 = 1wei * 10^18 = 1 ETH

        // Revert a tx consists in undoing any action performed before, and send remaining gas back to the msg.sender
        // E.G. 
        // Our local storage variable "number" was initialized to zero. Then arrives an invalid tx, which sends only 0.5ETH to the contract. 
        // Firstly, "number" is assigned to 5, but then, when at line 28 the tx is reverted, "number" gets back to its previous value 0. 
        // 
        // Only gas spent for previous instructions before the revert will be held, while other remaining gas will be sent back to the sender  

        // In order to get values outside the blockchain, we have to use offchain oracles like Chainlink
        // In this case we want to get the real-time change for ETH/USD pair
    
        // Record address of the sender and the amount of his funding 
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

        // Reset funders array assigning default value 0 
        funders = new address[](0);

        // withdraw funds
        // There are 3 different ways to send native blockchain currency (such ether):
        // 1) Transfer
        // 2) Send
        // 3) Call

        // ----- Transfer -----
        // transfer() is expensive (2300 gas, throws error)
        //
        // address(this) refers to the smart contract
        // payable() - to cast address type to a payable address type, which can receive ether
        //      msg.sender = address
        //      payable(msg.sender) = payable address
        //
        // payable(msg.sender).transfer(address(this).balance);
        //
        // --------------------

        // ----- Send -----
        // transfer() is expensive (2300 gas, returns bool)
        //
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");    // If send() fails, then tx would be reverted
        //
        // ----------------


        // ----- Call -----
        // call() - forwards all gas or set gas, returns bool
        // Low-Level function used to call virtually any function in all Ethereum without having ABI 
        // Is a real transaction
        // Returns (boolean, bytes), but in this case we only need the first return variable
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        //
        // ----------------

    }
}
