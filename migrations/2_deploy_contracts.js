var ConvertLib = artifacts.require("./ConvertLib.sol");
var BigNumber = require("bignumber.js");

var ElecList = artifacts.require("./ElecWhitelist.sol");
var ElecApprover = artifacts.require("./ElecApprover.sol");
var ElecSale = artifacts.require("./ElecSaleSmartContract.sol");
var adminAddress ="0x235387A976DCA51AC61283efAd64674734FEB4f4";
var multiSigWallet= "0xbF51a8D03025a60FA1a0BB5Bea22dd3AE9D45852";
var totalTokeSupply = new BigNumber(10).pow(18).mul(700000000);
var companyToken= new BigNumber(10).pow(18).mul(350000000);
var saleStartTime_second_from_now = Math.floor(Date.now() / 1000) +  5*60;
var firstRoundStarTime_second_from_now = Math.floor(Date.now() / 1000) +  15*60; /// change to 60 second to 6 hours = 6 * 60*60
var saleEndTime_second_from_now = Math.floor(Date.now() / 1000) +  30 * 60; /// change to 7 days= 60*60*24*7

var ElecListAddress="0x4323383fa3ba44262f4b11760b436a73d4ebe9b4";
var lockedDays = 7;

module.exports = function(deployer) {
 //deployer.deploy(ElecList);

 deployer.deploy(ElecSale, adminAddress, multiSigWallet, ElecListAddress, totalTokeSupply,
        companyToken, saleStartTime_second_from_now, firstRoundStarTime_second_from_now, saleEndTime_second_from_now, lockedDays);



};
