require("@nomiclabs/hardhat-web3");

const { task } = require("hardhat/config");

const tokenAddress = "0x1416094708F0F592332EE0E4D36f0FcE99915dE5";
const pancakeRouterAddress = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3";
const recipientAddress = "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc";
const wBnbAddress = "0xae13d989dac2f0debff460ac112a837c89baa7cd";
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
});
