const { parseEther } = require("ethers/lib/utils");

require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("amount", "Test amount", async (taskArgs, hre) => {
  const token = await ethers.getContractAt(
    "Oppa",
    "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"
  );

  console.log(token);
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
      url: "https://data-seed-prebsc-2-s1.binance.org:8545/",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: {
        mnemonic:
          "myth like bonus scare over problem client lizard pioneer submit female collect",
      },
    },
  },
  etherscan: {
    apiKey: "TWJ1BWSDDZAEMQKISXDAF5J6HRMU737U1W",
  },
};
