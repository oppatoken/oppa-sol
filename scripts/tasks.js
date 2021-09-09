require("@nomiclabs/hardhat-web3");

const { task } = require("hardhat/config");

const tokenAddress = "0xC7B0261c8e65b1d5fFA2eacd5529E583609c1EdF";

task("add", "Add liquidity", async (taskArgs, hre) => {
  const pancakeRouter = await ethers.getContractAt(
    "PancakeRouter",
    0x9ac64cc6e4415144c455bd8e4837fea55603e5c3
  );
  console.log(pancakeRouter);
});
