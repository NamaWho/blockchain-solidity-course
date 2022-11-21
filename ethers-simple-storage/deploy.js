// synchronous [solidity]
// asynchrounous [javascript]

// Synchronous action:
// 1. Put popcorn in microwave
// 2. Wait for popcorn to finish
// 3. Pour drinks for everyone [------]

// Asynchronous action:
// 1. Put popcorn in microwave --> Promise
// 2. Pour drinks for everyone [not related to the other actions, so there is no need to wait them to be finished]
// 3. Wait for popcorn to finish

// Promise
// > Pending
// > Fulfilled
// > Rejected

const ethers = require("ethers");
const fs = require("fs");

async function main() {
  // Compilation command via solcjs [yarn]
  // yarn solcjs --bin --abi --include-path node_modules --base-path . -o . SimpleStorage.sol
  // Compiling each time in this way could be annoying, so we add a script to our package.json

  // In order to connect to our local Ganache blockchain we connect to the RPC endpoint at http://127.0.0.1:7545
  // ethers is going to connect to the RPC endpoint automatically behind the scenes
  // This script is now going to connect with blockchain via the given enpoint url (blockchain node)
  const provider = new ethers.providers.JsonRpcProvider(
    "http://127.0.0.1:7545"
  );

  // Not a good practice, but useful to learn
  const wallet = new ethers.Wallet(
    "ad5d78cd52c03e967dad0be010458f40581d3c0818e110307aeff2908dfdf649",
    provider
  );

  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );

  // A Contract Factory is used by ehters to deploy contract
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);

  console.log("Deploying , please wait...");
  const contract = await contractFactory.deploy(); // STOP here! Wait for contract to deploy

  console.log(contract);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
