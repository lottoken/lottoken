pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/PausableToken.sol';

contract LottokenCoin is MintableToken, Pausable {
  string public name = "LOTTOKEN COIN";
  string public symbol = "LOTT";
  uint256 public decimals = 0;


uint public INITIAL_SUPPLY = 1000000000000;

function LottokenCoin() {
  totalSupply = INITIAL_SUPPLY;
  balances[msg.sender] = INITIAL_SUPPLY;
}



}
