const { expect } = require('chai');

describe('EnrileFinance', function () {
  it('it should deploy EnrileFinance', async function () {
    const EnrileFinance = await ethers.getContractFactory('EnrileFinance');
    const enrileFinance = await EnrileFinance.deploy();
    const deployed = await enrileFinance.deployed();
  });
});
