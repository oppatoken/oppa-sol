const getDeployer = async (x) => {
  const accounts = await hre.ethers.getSigners();
  return accounts[0].address;
};

module.exports = getDeployer;
