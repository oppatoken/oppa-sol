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
  const Standard = await ethers.getContractFactory("Standard", {
    libraries: {
      IterableMapping: "0x91282A04D174873C3e6C4798850aCB14B1189cC7",
    },
  });
  const standard = await Standard.deploy();

  console.log("Standard ADDRESS: ", standard.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
