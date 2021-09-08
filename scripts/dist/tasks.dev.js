"use strict";

require("@nomiclabs/hardhat-web3");

var _require = require("hardhat/config"),
    task = _require.task;

var tokenAddress = "0xC7B0261c8e65b1d5fFA2eacd5529E583609c1EdF";
task("add", "Add liquidity", function _callee(taskArgs, hre) {
  var token, balance;
  return regeneratorRuntime.async(function _callee$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.next = 2;
          return regeneratorRuntime.awrap(ethers.getContractAt("Standard", tokenAddress));

        case 2:
          token = _context.sent;
          _context.next = 5;
          return regeneratorRuntime.awrap(token.balanceOf("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"));

        case 5:
          balance = _context.sent;
          console.log(balance.toString());
          _context.next = 9;
          return regeneratorRuntime.awrap(token.mockLiquidity());

        case 9:
        case "end":
          return _context.stop();
      }
    }
  });
});