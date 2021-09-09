// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

const hre = require("hardhat");
const pancakeRouterAbi = require("../assets/abi/pancakeRouter.json");

async function main() {
  /**
   * @function deploys oppa token
   */
  // const Factory = await ethers.getContractFactory("Factory");
  // const factory = await Factory.deploy({
  //   gasPrice: "2000000000000000000000000000000",
  // });

  // console.log("Factory Address:  ", factory.address);

  const pancakeRouter = await ethers.getContractFactory(
    "PancakeRouter",
    pancakeRouterAbi,
    0x9ac64cc6e4415144c455bd8e4837fea55603e5c3
  );

  console.log(pancakeRouter);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
