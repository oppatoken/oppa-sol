// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const { Web3 } = require("hardhat");
const hre = require("hardhat");

async function main() {
  /**
   * @function deploys oppa token
   * - Iterable has already been deployed on the testnet
   */
  const Oppa = await ethers.getContractFactory("Oppa", {
    libraries: {
      IterableMapping: "0x68d2204b7548c6506816b3584418953b6D7Dad41",
    },
  });
  const oppa = await Oppa.deploy();

  console.log("Oppa ADDRESS: ", oppa.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
