require("@nomiclabs/hardhat-web3");

const { task } = require("hardhat/config");

const tokenAddress = "0xC7B0261c8e65b1d5fFA2eacd5529E583609c1EdF";

task("add", "Add liquidity", async (taskArgs, hre) => {
  const token = await ethers.getContractAt("Standard", tokenAddress);
  const balance = await token.balanceOf(
    "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
  );
  console.log(balance.toString());
  await token.mockLiquidity();
});
