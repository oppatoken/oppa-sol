const { expect } = require("chai");

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
    expect(await oppaDeployed.balanceOf(owner.address)).to.equal(
      await oppaDeployed.totalSupply()
    );
  });

  // @TODO: test rewards
});
