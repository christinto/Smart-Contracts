pragma solidity ^0.4.13;

import '../../../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol';

contract ElecToken is MintableToken {
    string public name = "ElecToken";
    string public symbol = "ELEC";
    uint256 public decimals = 18;
}