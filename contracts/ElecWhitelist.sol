pragma solidity ^0.4.0;

import './zeppelin/ownership/Ownable.sol';

contract ElecWhitelist is Ownable {
    // cap is in wei. The value of 7 is just a stub.
    // after kyc registration ends, we change it to the actual value with setsersCap
    uint public communityusersCap = 7;
    mapping(address=>uint) public addressCap;

    function ElecWhitelist() {}

    event ListAddress( address _user, uint _cap, uint _time );

    // Owner can delist by setting cap = 0.
    // Onwer can also change it at any time
    function listAddress( address _user, uint _cap ) onlyOwner {
        addressCap[_user] = _cap;
        ListAddress( _user, _cap, now );
    }

    // an optimization in case of network congestion
    function listAddresses( address[] _users, uint[] _cap ) onlyOwner {
        require(_users.length == _cap.length );
        for( uint i = 0 ; i < _users.length ; i++ ) {
            listAddress( _users[i], _cap[i] );
        }
    }

    function setUsersCap( uint _cap ) onlyOwner {
        communityusersCap = _cap;
    }

    function getCap( address _user ) constant returns(uint) {
        uint cap = addressCap[_user];

        if( cap == 1 ) return communityusersCap;
        else return cap;
    }

    function destroy() onlyOwner {
        selfdestruct(owner);
    }
}
