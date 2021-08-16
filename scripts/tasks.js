const { parseEther } = require("ethers/lib/utils");
const { task } = require("hardhat/config");

task("amount", "Test amount", async (taskArgs, hre) => {
  const token = await ethers.getContractAt(
    "Oppa",
    "0xFd6a2Af23f79689CcB14D865c39a53a1c90EDF92"
  );

  await token.burn("200000000000000000000000000000000");
});

task("factory", "Add LP", async (taskArgs, hre) => {
  const tokenAddress = "0x24695615e9b2b089eA7B88A20fc5852c457d74A9";

  const token = await ethers.getContractAt("Oppa", tokenAddress);

  await token.approve(
    "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",
    "200000000000000"
  );

  await token.setSwapAndLiquifyEnabled(false);

  const [account] = await (
    await hre.ethers.getSigners()
  ).map(({ address }) => address);

  //   const addressBalance = await token.balanceOf(account);

  const router = await ethers.getContractAt(
    "IPancakeRouter02",
    "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"
  );

  /**@dev approve address 0 first */
});
