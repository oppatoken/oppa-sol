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

  const Iterable = await ethers.getContractFactory("IterableMapping");
  const iterable = await Iterable.deploy();

  console.log("ITERABLE ADDRESS: ", iterable.address);
  // const OppaTwo = await ethers.getContractFactory("OppaTwo", {
  //   libraries: {
  //     IterableMapping: iterable.address,
  //   },
  // });
  // const oppaTwo = await OppaTwo.deploy();
  // console.log("TOKEN ADDRESS: ", oppaTwo.address);

  const Factory = await ethers.getContractFactory("Factory", {
    libraries: {
      IterableMapping: iterable.address,
    },
  });

  const factory = await Factory.deploy();
  console.log("FACTORY ADDRESS: ", factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
