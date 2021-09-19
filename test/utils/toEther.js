const { web3 } = require("hardhat");

const formatComma = require("./number");

const toEther = (amount = "") => {
  return formatComma(web3.utils.fromWei(amount, "ether"));
};

module.exports = toEther;
