pragma solidity ^0.4.0;

/*

# Copyright 2018 Electrify Pte Ltd

Airdrop mechanism (for consideration) to announced only after ICO.

1.1% dropped evenly to all whitelisted participants (as long as they filled up our form)

1.5% dropped to ETH owners proportional to ETH balance (above min. balance of _ ETH, determined at block height __)

1.5% dropped to OMG owners proportional to OMG balance (above min. balance of _ OMG, determined at block height __)


*/

import './ElecTokenSmartContract.sol';
import './ElecWhitelist.sol';
import './zeppelin/math/SafeMath.sol';


contract ElecAirdropSmartContract is Ownable {
    uint    public whitelistAmount;
    uint    public ethereumAmount;
    uint    public omgAmount;

    uint    public whitelistDropped;
    uint    public ethereumDropped;
    uint    public omgDropped;


    uint    public perWhitelist = 10 * (10**18); /// in wei
    uint    public whiteListCap = (10**18); /// change to 1.067 in the mainet

    address public admin;
    address public hdWallet;
    bool    public haltAirdrop;

    using SafeMath for uint;


    ElecTokenSmartContract  public elecToken; /// change it when the real address deployment
    ElecWhitelist   public whitelist; /// change it for the mainnet address deployment

    function ElecAirdropSmartContract(uint _whitelistAmount, uint _ethereumAmount, uint _omgAmount, address _admin, address _hdWallet, ElecTokenSmartContract _elecToken, ElecWhitelist _whitelist) public {
        whitelistAmount = _whitelistAmount;
        ethereumAmount = _ethereumAmount;
        omgAmount = _omgAmount;
        admin = _admin;
        hdWallet = _hdWallet;
        elecToken = _elecToken;
        whitelist = _whitelist;
    }




    function setHaltAirdrop(bool _halt) public {
        require(msg.sender == admin);
        haltAirdrop = _halt;
    }



    event ElecAirdropForWhiteList(address _whitelistAddress, uint _amount);
    /// for whitelist airdrop function
    function elecAirdropForWhiteLists(address[] _whitelistAddresses) public onlyOwner {
        require(!haltAirdrop);

        for( uint i = 0; i < _whitelistAddresses.length; i++) {
            require(whitelist.getCap(_whitelistAddresses[i]) == whiteListCap);

            require( whitelistDropped <= whitelistAmount);

            assert(elecToken.transfer(_whitelistAddresses[i],perWhitelist));

            whitelistDropped.add(perWhitelist);

            ElecAirdropForWhiteList(_whitelistAddresses[i],perWhitelist);
        }
    }



    event ElecAirdropForEthereumAcc(address _ethereumAddress, uint _amount);
    /// for multi-ethereum accounts
    function elecAirdropForEthereumAccs(address[] _ethereumAddresses, uint[] _amounts) public onlyOwner {

        require(!haltAirdrop);
        require( _ethereumAddresses.length == _amounts.length);

        for ( uint i=0; i < _ethereumAddresses.length; i++) {

            require( ethereumDropped <= ethereumAmount);

            assert(elecToken.transfer(_ethereumAddresses[i], _amounts[i]));

            ethereumDropped.add(_amounts[i]);

            ElecAirdropForEthereumAcc(_ethereumAddresses[i], _amounts[i]);
        }
    }


    event ElecAirdropForOmgAcc(address _omgAddress, uint _amount);
    /// for multi Airdrop accounts
    function elecAirdropForOmgAccs(address[] _omgAddresses, uint[] _amounts) public onlyOwner {
        require(!haltAirdrop);

        require (_omgAddresses.length <= _amounts.length);

        for (uint i=0; i < _omgAddresses.length; i++) {

            require( omgDropped <= omgAmount);

            assert(elecToken.transfer(_omgAddresses[i], _amounts[i]));

            omgDropped.add(_amounts[i]);

            ElecAirdropForOmgAcc(_omgAddresses[i], _amounts[i]);
        }
    }


    /// emergencyDrain token
    function emergencyDrain() public returns(bool) {
        require(msg.sender == admin);
        assert(elecToken.transfer(hdWallet, elecToken.balanceOf(this)));
        return true;
    }

}
