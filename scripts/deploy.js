// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const { parseEther, formatEther } = require("@ethersproject/units");
const hre = require("hardhat");

async function main() {
  /**
   * @function deploys oppa token
   * - In running this locally make sure to run the forked testnet
   * - Or else, deploy an iterable instance of the IterableMapping contract locally first
   * - And replace the library reference below IterableMapping
   */
  const Oppa = await ethers.getContractFactory("Oppa", {
    libraries: {
      IterableMapping: "0x71784F9F113ADC6B19F84fcE6035ebA2FbD4d4B4",
    },
  });
  const oppa = await Oppa.deploy();

  console.log("Oppa ADDRESS: ", oppa.address);

  /**
   * @dev BURN BEFORE LISTING 50% of total supply  50,000,000,000,000,000.00
   */

  await oppa.transfer(
    "0x9Cfab6B4DcA8917600E0c62664a467Dd66643bE3",
    `${parseEther("10000")}`
  );

  console.log(
    "PRE-BALANCE: ",
    formatEther(
      await (
        await oppa.balanceOf("0x9Cfab6B4DcA8917600E0c62664a467Dd66643bE3")
      ).toString()
    )
  );

  await oppa.addRewardee("0x9Cfab6B4DcA8917600E0c62664a467Dd66643bE3");

  console.log(
    "POST-BALANCE: ",
    formatEther(
      await (
        await oppa.balanceOf("0x9Cfab6B4DcA8917600E0c62664a467Dd66643bE3")
      ).toString()
    )
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
