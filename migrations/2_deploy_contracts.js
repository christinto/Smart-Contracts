var ConvertLib = artifacts.require("./ConvertLib.sol");
var BigNumber = require("bignumber.js");

var ElecList = artifacts.require("./ElecWhitelist.sol");
var ElecSale = artifacts.require("./ElecSaleSmartContract.sol");
var adminAddress ="0x235387A976DCA51AC61283efAd64674734FEB4f4";
var multiSigWallet= "0xDF454f7AEA8c5Df3C10B50922aa190526c49Cf04";
var totalTokeSupply = new BigNumber(10).pow(18).mul(750000000);
var companyToken= new BigNumber(10).pow(18).mul(749920000);
var saleStartTime_second_from_now = Math.floor(Date.now() / 1000) +  5 *60;
var firstRoundStarTime_second_from_now = Math.floor(Date.now() / 1000) +  50*60; /// change to 60 second to 6 hours = 6 * 60*60
var saleEndTime_second_from_now = Math.floor(Date.now() / 1000) +   95* 60; /// change to 7 days= 60*60*24*7

var ElecListAddress="0x7c20e0a4185d3382ef7c7ccbf58351423607ae90";
var lockedDays = 1;

var deck = artifacts.require("./Deck.sol");

module.exports = function(deployer) {
 //deployer.deploy(ElecList);


 deployer.deploy(ElecSale, adminAddress, multiSigWallet, ElecListAddress, totalTokeSupply,
        companyToken, saleStartTime_second_from_now, firstRoundStarTime_second_from_now, saleEndTime_second_from_now, lockedDays);



};
