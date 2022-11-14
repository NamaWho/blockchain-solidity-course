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

// or

// Importing the same interface from NPM (as a package)
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Allows addresses to raise funds for themselves
// Get funds from users
// Withdraw funds
// Set a minimum funding value
contract FundMe {

    // uint256 public number;
    uint256 public minimumUSD = 50;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // Want to be able to set a minim funding value
        // How does the contract receive ETH?
        // Remember how a TX is composed:
        // - Nonce > tx count for the account
        // - Gas Price > price per unit of gas (in wei)
        // - Gas Limit > 21000
        // - To > address that the tx is sent to (in this case the contract address)
        // - Value > amount of wei to send
        // - Data > what to send to the To address
        // - v, r, s > components of tx signature
        // In order to receive ETH, it has to be marked as 'payable'
        // To access to the ETH received, use msg.value
        
        // number = 5
        require(getConversionRate(msg.value) >= minimumUSD, "Did not receive enough ETH"); // 1e18 = 1wei * 10^18 = 1 ETH

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

    function getPrice() public view returns (uint256) {
        // Need to interact with Chainlink Data Feed
        // ABI
        // Address (Goerly network) - https://docs.chain.link/docs/data-feeds/price-feeds/addresses/#Goerli%20Testnet [0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e]

        // This AggregatorV3Interface lets us to link the needed data feed with an existent Chainlink interface in order to get data in a standard way.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

        (, int256 price,,,) = priceFeed.latestRoundData();

        // Remembering that an ETH has 18 decimals 
        // 1.0000000000000000000 [18 zeros]
        // Instead ETH in terms of USD
        // 3000.00000000 [8 decimals]
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();

        // ALWAYS MULTIPLY BEFORE DIVIDING
        // Example
        // ethPrice = 3000_0000000000000000000  ETH/USD price [18 decimals]
        // ethAmount = 1_000000000000000000     ETH [18 decimals]
        // ethPrice * ethAmount = 3000_00000000000000000000000000000000000000 [36 decimals]
        // ethAmountInUsd = 3000_0000000000000000000 [18 decimals]

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }

}
