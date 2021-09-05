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
  const OppaTwo = await ethers.getContractFactory("OppaTwo", {
    libraries: {
      IterableMapping: "0x59BCEbd2479E9f6aCD594bA683Afa3c9323788Ec",
    },
  });
  const oppaTwo = await OppaTwo.deploy();
  console.log("TOKEN ADDRESS: ", oppaTwo.address);
  console.log("Pair ADDRESS: ", await oppaTwo.pancakePair());
  console.log("Pair ADDRESS: ", await oppaTwo.pancakeRouter02());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
