pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract LottokenCoin is MintableToken {
  string public name = "LOTTOKEN COIN";
  string public symbol = "LOTT";
  uint256 public decimals = 0;
}
