pragma solidity ^0.4.0;

import './zeppelin/ownership/Ownable.sol';
import './ElecWhitelist.sol';
import './zeppelin/math/SafeMath.sol';

contract ElecApprover {
    ElecWhitelist public list;
    mapping(address=>uint)    public participated;

    uint                      public saleStartTime;
    uint                      public firstRoundTime;
    uint                      public saleEndTime;
    uint                      public xtime = 5;

    using SafeMath for uint;


    function ElecApprover( ElecWhitelist _whitelistContract,
    uint                      _saleStartTime,
    uint                      _firstRoundTime,
    uint                      _saleEndTime ) {
        list = _whitelistContract;
        saleStartTime = _saleStartTime;
        firstRoundTime = _firstRoundTime;
        saleEndTime = _saleEndTime;

        require( list != ElecWhitelist(0x0) );
        require( saleStartTime < firstRoundTime );
        require(  firstRoundTime < saleEndTime );
    }

    // this is a seperate function so user could query it before crowdsale starts
    function contributorCap( address contributor ) constant returns(uint) {
        uint  cap= list.getCap( contributor );
        uint higherCap = cap;

        if ( now > firstRoundTime ) {
            higherCap = cap.mul(xtime);
        }
        return higherCap;
    }


    function eligible( address contributor, uint amountInWei ) constant returns(uint) {
        if( now < saleStartTime ) return 0;
        if( now >= saleEndTime ) return 0;

        uint cap = list.getCap( contributor );

        if( cap == 0 ) return 0;

        uint higherCap = cap;
        if ( now > firstRoundTime ) {
            higherCap = cap.mul(xtime);
        }

        uint remainedCap = higherCap.sub(participated[ contributor ]);
        if( remainedCap > amountInWei ) return amountInWei;
              else return remainedCap;

    }

    function eligibleTestAndIncrement( address contributor, uint amountInWei ) internal returns(uint) {
        uint result = eligible( contributor, amountInWei );
        if ( result > 0) {
            participated[contributor] = participated[contributor].add( result );
        }
        return result;
    }


    function contributedCap(address _contributor) constant returns(uint) {
        return participated[_contributor];
    }

    function saleEnded() constant returns(bool) {
        return now > saleEndTime;
    }

    function saleStarted() constant returns(bool) {
        return now >= saleStartTime;
    }
}
