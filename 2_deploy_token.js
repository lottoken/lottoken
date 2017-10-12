
const LottokenCoinCrowdsale = artifacts.require("./LottokenCoinCrowdsale.sol")

module.exports = function(deployer, network, accounts) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  const endTime = startTime + (86400 * 20) // 20 days
  const rate = new web3.BigNumber(100)
//  const rate = new web3.BigNumber(0.0000000000000001)
  const wallet = accounts[0]

  deployer.deploy(LottokenCoinCrowdsale, startTime, endTime, rate, wallet)
};
