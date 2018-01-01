pragma solidity ^0.4.0;

import './ElecTokenSmartContract.sol';
import './ElecApprover.sol';
import './ElecWhitelist.sol';

contract ElecSaleSmartContract is ElecApprover{
    address             public admin;
    address             public multiSigWallet; // can be a single wallet
    ElecTokenSmartContract public token;
    uint                public raisedWei;
    bool                public haltSale;

    mapping(bytes32=>uint) public proxyPurchases;

    function ElecSaleSmartContract( address _admin,
    address _multiSigWallet,
    ElecWhitelist _whiteListContract,
    uint _totalTokenSupply,
    uint _premintedTokenSupply,
    uint _cappedSaleStartTime,
    uint _publicSaleStartTime,
    uint _publicSaleEndTime )

    ElecApprover( _whiteListContract,
    _cappedSaleStartTime,
    _publicSaleStartTime,
    _publicSaleEndTime )
    {
        admin = _admin;
        multiSigWallet = _multiSigWallet;

        token = new ElecTokenSmartContract( _totalTokenSupply,
        _cappedSaleStartTime,
        _publicSaleEndTime + 7 days, /// 7 can changed depending on each project
        _admin );

        // transfer preminted tokens to company wallet
        token.transfer( multiSigWallet, _premintedTokenSupply );
    }

    function setHaltSale( bool halt ) {
        require( msg.sender == admin );
        haltSale = halt;
    }

    function() payable {
        buy( msg.sender );
    }

    event ProxyBuy( bytes32 indexed _proxy, address _recipient, uint _amountInWei );
    function proxyBuy( bytes32 proxy, address recipient ) payable returns(uint){
        uint amount = buy( recipient );
        proxyPurchases[proxy] = proxyPurchases[proxy].add(amount);
        ProxyBuy( proxy, recipient, amount );

        return amount;
    }

    event Buy( address _buyer, uint _tokens, uint _payedWei );
    function buy( address recipient ) payable returns(uint){
        require( tx.gasprice <= 50000000000 wei );

        require( ! haltSale );
        require( saleStarted() );
        require( ! saleEnded() );

        uint weiPayment = eligibleTestAndIncrement( recipient, msg.value );

        require( weiPayment > 0 );

        // send to msg.sender, not to recipient
        if( msg.value > weiPayment ) {
            msg.sender.transfer( msg.value.sub( weiPayment ) );
        }

        // send payment to wallet
        sendETHToMultiSig( weiPayment );
        raisedWei = raisedWei.add( weiPayment );
        uint recievedTokens = weiPayment.mul( 5000 );

        assert( token.transfer( recipient, recievedTokens ) );


        Buy( recipient, recievedTokens, weiPayment );

        return weiPayment;
    }

    function sendETHToMultiSig( uint value ) internal {
        multiSigWallet.transfer( value );
    }

    event FinalizeSale();
    // function is callable by everyone
    function finalizeSale() {
        require( saleEnded() );
        require( msg.sender == admin );

        // burn remaining tokens
        token.burn(token.balanceOf(this));

        FinalizeSale();
    }

    // ETH balance is always expected to be 0.
    // but in case something went wrong, we use this function to extract the eth.
    function emergencyDrain(ERC20 anyToken) returns(bool){
        require( msg.sender == admin );
        require( saleEnded() );

        if( this.balance > 0 ) {
            sendETHToMultiSig( this.balance );
        }

        if( anyToken != address(0x0) ) {
            assert( anyToken.transfer(multiSigWallet, anyToken.balanceOf(this)) );
        }

        return true;
    }

    // just to check that funds goes to the right place
    // tokens are not given in return
    function debugBuy() payable {
        require( msg.value == 123 );
        sendETHToMultiSig( msg.value );
    }
}