var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var BigNumber = require("bignumber.js");

var ElecList = artifacts.require("./ElecWhitelist.sol");
var ElecApprover = artifacts.require("./ElecApprover.sol");
var ElecSale = artifacts.require("./ElecSaleSmartContract.sol");
var adminAddress ="0x0fc339d948a258ab986b71ef7fd78530a824d63a";
var multiSigWallet= "0xbF51a8D03025a60FA1a0BB5Bea22dd3AE9D45852";
var totalTokeSupply = new BigNumber(10).pow(18).mul(25000000);
var forCompany= new BigNumber(10).pow(18).mul(10000000);
var cappedSale_second_from_now = Math.floor(Date.now() / 1000) +  120;
var saleStartTime_second_from_now = Math.floor(Date.now() / 1000) +  600;
var saleEndTime_second_from_now = Math.floor(Date.now() / 1000) +  3600*24;

var ElecListAddress="0x37339c780fbcb2761617ba19d070eb3898b6d785";

module.exports = function(deployer) {
 /* deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);*/
 // deployer.deploy(ElecList);
   deployer.deploy(ElecApprover, ElecListAddress, cappedSale_second_from_now, saleStartTime_second_from_now, saleEndTime_second_from_now);
/*

  deployer.deploy(ElecSale, adminAddress, multiSigWallet, ElecListAddress, totalTokeSupply,
        forCompany, cappedSale_second_from_now, saleStartTime_second_from_now, saleEndTime_second_from_now);
*/


};
