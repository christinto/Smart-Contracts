var Migrations = artifacts.require("./Migrations.sol");
var Bignumber = require("bignumber.js");

var elecAirDropSmartContract = artifacts.require("./ElecAirdropSmartContract.sol");
var elecTokenAddress="0xd8e24e5f8538d9b7df03f23f74eed435f3a62e77";
var whitelistAddress="0x7c20e0a4185d3382ef7c7ccbf58351423607ae90";
var whitelistAmount = new Bignumber(10).pow(18).mul(1000);
var ethereumAmount = new Bignumber(10).pow(18).mul(1500);
var omgAmount = new Bignumber(10).pow(18).mul(1500);
var adminAddress ="0x235387A976DCA51AC61283efAd64674734FEB4f4";
var hdWallet ="0xbF51a8D03025a60FA1a0BB5Bea22dd3AE9D45852";



module.exports = function(deployer) {
  ///deployer.deploy(Migrations);
  deployer.deploy(elecAirDropSmartContract, whitelistAmount, ethereumAmount, omgAmount, adminAddress, hdWallet, elecTokenAddress, whitelistAddress);
};
