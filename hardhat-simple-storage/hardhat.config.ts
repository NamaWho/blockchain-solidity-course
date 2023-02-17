// require("@nomicfoundation/hardhat-toolbox")
// require("dotenv").config()
// require("@nomiclabs/hardhat-etherscan")
// require("hardhat-gas-reporter")
// require("solidity-coverage")

import "@nomicfoundation/hardhat-toolbox"
import "dotenv/config"
import "@nomiclabs/hardhat-etherscan"
import "hardhat-gas-reporter"
import "solidity-coverage";
import "@typechain/hardhat"

// Custom Tasks
require("./tasks/accounts")
require("./tasks/block-number")

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || "_"
const PRIVATE_KEY = process.env.PRIVATE_KEY || "_"
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "_"
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "_"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat", // by default hardhat network selected (PK already bundled)
    networks: {
        goerli: {
            // select a different network to run on typing --network [name]
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 5,
        },
        localhost: {
            url: "http://127.0.0.1:8545/",
            // accounts are replaced automatically by hardhat
            chainId: 31337,
        },
    },
    solidity: "0.8.8",
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    gasReporter: {
        enabled: false,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKETCAP_API_KEY,
        // token: "MATIC" // Specify token to see how it would cost on a particular blockchain
    },
}
