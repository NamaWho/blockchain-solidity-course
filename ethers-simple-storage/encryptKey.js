const ethers = require("ethers");
const fs = require("fs");
require("dotenv").config();

// Used to encrypt PRIVATE_KEY passing via command line the PRIVATE_KEY and PASSWORD to encrypt it with
// PRIVATE_KEY=0x02334bbbd... PASSWORD=password node encryptKey.js
// It will generate a new json file where encrypted private key is stored
// This will be parsed in deploy.js to retrieve pk and create the wallet

// ATTENTION!!!
// Right after encryption clear your command line history with `history -c`

async function main() {
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
  const encryptedJsonKey = await wallet.encrypt(
    process.env.PRIVATE_KEY_PASSWORD,
    process.env.PRIVATE_KEY
  );
  console.log(encryptedJsonKey);

  fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
