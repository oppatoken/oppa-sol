// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const hre = require("hardhat");

async function main() {
  /**
   * @function deploys oppa token
   */
  const Dara = await ethers.getContractFactory("Dara", {
    libraries: {
      IterableMapping: "0x71784F9F113ADC6B19F84fcE6035ebA2FbD4d4B4",
    },
  });
  const dara = await Dara.deploy();

  console.log("Dara ADDRESS: ", dara.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
