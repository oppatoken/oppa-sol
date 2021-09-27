const { expect } = require("chai");
const getDeployer = require("./utils/accounts");
const toEther = require("./utils/toEther");

describe("Oppa Token", function () {
  let OppaToken;
  let owner;
  let oppaDeployed;

  this.beforeEach(async () => {
    OppaToken = await ethers.getContractFactory("Oppa", {
      libraries: {
        IterableMapping: "0x71784F9F113ADC6B19F84fcE6035ebA2FbD4d4B4",
      },
    });

    owner = await (await ethers.getSigners())[0];

    const oppaToken = await OppaToken.deploy();
    oppaDeployed = await oppaToken.deployed();
  });

  it("Owner balance should be token supply", async function () {
    console.log("Owner balance should be token supply");
    expect(await oppaDeployed.balanceOf(owner.address)).to.equal(
      await oppaDeployed.totalSupply()
    );

    console.log(toEther(await (await oppaDeployed.totalSupply()).toString()));
  });

  it("Owner balance should be token supply after burning", async function () {
    await oppaDeployed.burn(
      `${await (await oppaDeployed.totalSupply()).div(2)}`
    );

    expect(
      await oppaDeployed.balanceOf(owner.address),
      "Owner Balance"
    ).to.equal(await (await oppaDeployed.totalSupply()).div(2));
  });
});
