// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  /**
   * @function deploys enrile finance
   */
  // const EnrileFinance = await ethers.getContractFactory('EnrileFinance');
  // const token = await EnrileFinance.deploy();
  // await token.mint("0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1", parseEther(`${20000000}`).toString());
  // console.log(token.address);
  // /**
  //  * @function deploys ILO
  //  */
  // const ILO = await ethers.getContractFactory('ILO');
  // const ilo = await ILO.deploy();
  // console.log(ilo.address);
  const Oppa = await ethers.getContractFactory("Oppa");
  const oppa = await Oppa.deploy();
  console.log(oppa.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
