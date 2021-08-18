require("@nomiclabs/hardhat-web3");

const { task } = require("hardhat/config");

const tokenAddress = "0xd3384611b82ad4B456Ce735B5051c072942d36C2";
const pancakeRouterAddress = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3";
const recipientAddress = "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc";

function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

task("burn", "Test amount", async (taskArgs, hre) => {
  const token = await ethers.getContractAt("Oppa", tokenAddress);

  await token.burn("200000000000000000000000000000000");
});

task("factory", "Add LP", async (taskArgs, hre) => {
  const { fromWei, toWei } = web3.utils;
  const token = await ethers.getContractAt("Oppa", tokenAddress);

  const [account] = await (
    await hre.ethers.getSigners()
  ).map(({ address }) => address);

  console.log(
    "Current Oppa Supply:",
    numberWithCommas(fromWei(await (await token.totalSupply()).toString()))
  );

  console.log(
    "Deployer Token Balance:",
    numberWithCommas(fromWei(await (await token.balanceOf(account)).toString()))
  );

  const router = await ethers.getContractAt(
    "IPancakeRouter02",
    pancakeRouterAddress
  );

  await token._transferStandard(account, recipientAddress, toWei("100"));

  console.log(
    "Senders's Balance:",
    numberWithCommas(fromWei(await (await token.balanceOf(account)).toString()))
  );
  console.log(
    "Recipient's Balance:",
    numberWithCommas(
      fromWei(await (await token.balanceOf(recipientAddress)).toString())
    )
  );

  console.log(
    "Current Oppa Supply:",
    numberWithCommas(fromWei(await (await token.totalSupply()).toString()))
  );

  /**@dev approve address 0 first */
});
