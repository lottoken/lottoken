pragma solidity ^0.4.13;
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract TutorialToken is StandardToken {

string public name = 'TutorialToken';
string public symbol = 'LOTT';
uint public decimals = 1;
uint public INITIAL_SUPPLY = 13000;

function TutorialToken() {
  totalSupply = INITIAL_SUPPLY;
  balances[msg.sender] = INITIAL_SUPPLY;
}



}
