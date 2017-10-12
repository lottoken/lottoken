pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/PausableToken.sol';

contract LottokenCoin is MintableToken, Pausable {
  string public name = "LOTTOKEN COIN";
  string public symbol = "LOTT";
  uint256 public decimals = 18;
//  uint256 public decimals = 0;
}
