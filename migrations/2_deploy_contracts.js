var ConvertLib = artifacts.require("./ConvertLib.sol");
var BigNumber = require("bignumber.js");

var ElecList = artifacts.require("./ElecWhitelist.sol");
var ElecApprover = artifacts.require("./ElecApprover.sol");
var ElecSale = artifacts.require("./ElecSaleSmartContract.sol");
var adminAddress ="0x235387A976DCA51AC61283efAd64674734FEB4f4";
var multiSigWallet= "0xbF51a8D03025a60FA1a0BB5Bea22dd3AE9D45852";
var totalTokeSupply = new BigNumber(10).pow(18).mul(25000000);
var forCompany= new BigNumber(10).pow(18).mul(10000000);
var cappedSale_second_from_now = Math.floor(Date.now() / 1000) +  30;
var saleStartTime_second_from_now = Math.floor(Date.now() / 1000) +  60;
var saleEndTime_second_from_now = Math.floor(Date.now() / 1000) +  3600*24;

var ElecListAddress="0x7ef5c256f224b4157117872ed44e8afc0686b215";

module.exports = function(deployer) {
 //deployer.deploy(ElecList);
  // deployer.deploy(ElecApprover, ElecListAddress, cappedSale_second_from_now, saleStartTime_second_from_now, saleEndTime_second_from_now);



 deployer.deploy(ElecSale, adminAddress, multiSigWallet, ElecListAddress, totalTokeSupply,
        forCompany, cappedSale_second_from_now, saleStartTime_second_from_now, saleEndTime_second_from_now);




};
