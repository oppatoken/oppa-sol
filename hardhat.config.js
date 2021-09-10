const { parseEther } = require("ethers/lib/utils");

require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

require("./scripts/tasks");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.6.12",
  defaultNetwork: "localhost",
  networks: {
    testnet: {
      url: `${process.env.TEST_NET_URL}`,
      chainId: 97,
      gas: 21000000000,
      gasPrice: 21000000000,
      accounts: {
        mnemonic: `${process.env.MNEMONIC}`,
      },
    },
    mainnet: {
      url: `${process.env.MAINNET_URL}`,
      chainId: 56,
      gas: 21000000000,
      gasPrice: 21000000000,
      accounts: {
        mnemonic: `${process.env.MNEMONIC}`,
      },
    },
  },
  etherscan: {
    apiKey: `${process.env.ETHERSCAN_API_KEY}`,
  },
};
