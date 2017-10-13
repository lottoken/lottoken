pragma solidity ^0.4.13;

import './LottokenCoin.sol';
import 'zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol';


contract LottokenCoinCrowdsale is FinalizableCrowdsale {

  function LottokenCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)
    Crowdsale(1507849260, 1509577260, 100, 0x5cE5940aC3908a07C0c0e6080E6975CD96fac006) {
}

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    return new LottokenCoin();
  }

}
