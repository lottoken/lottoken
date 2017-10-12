/* global artifacts, contract, it, assert */
var BigNumber = require('bignumber.js')
var LottokenCoinCrowdsale = artifacts.require('./LottokenCoinCrowdsale.sol')
var LottokenCoin = artifacts.require('./LottokenCoin.sol')
var Lotto = artifacts.require('./Lotto.sol')

const assertJump = require('./helpers/assertJump')


/**
 * Some sanity tests against the Zeppelin standard token contract
 */
contract('LottokenCoinCrowdsale', (accounts) => {
  it('should deploy', () => {
    return LottokenCoinCrowdsale.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Instance should not be null')
    })
  })

  it('should have correct initial values set.', async () => {

let crowdsale = await LottokenCoinCrowdsale.deployed()

const token_address_from_crowdsale = await crowdsale.token()

//console.log('token address', token_address_from_crowdsale)

contract('Lotto', (accounts) => {
  it('should deploy', () => {
    return Lotto.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Lotto Instance should not be null')
    })
  })

  it('everything should work.', async () => {

	let lto = await Lotto.deployed()
	await lto.set_sta(token_address_from_crowdsale)

        let token = await LottokenCoin.at(token_address_from_crowdsale)

	let symbol = await token.symbol()
	assert.equal(symbol, 'LOTT')

	let name = await token.name()
	assert.equal(name, 'LOTTOKEN COIN')

//	let totalSuppy = await token.totalSupply()
//    assert.equal(new BigNumber(totalSuppy).toString(), new BigNumber(13000).toString(), 'Initial supply should be 13 Thousand')
//	console.log('Max supply', new BigNumber(totalSuppy).toString())

	let buyer = accounts[1]

	let balanceBefore = await token.balanceOf(buyer)
	assert.equal(balanceBefore, 0)

	await crowdsale.sendTransaction( {value: web3.toWei(0.01,"ether") , from: buyer})

	let balanceAfter = await token.balanceOf(buyer)
	
	console.log('Just bought', new BigNumber(web3.fromWei(balanceAfter, "ether")).toString(), 'Lottokens')


// p= 1st participant, p2 = 2nd participant, o = organizer, t = trigger
    let o = accounts[1]
    let p = accounts[2]
    let t = accounts[3]
    let p2 = accounts[4]
    let p3 = accounts[5]

/*

//now lets transfer 10 coins to all accounts so that they are set up for the contest

    // Verify the before balance
    let balanceBefore_organizer = await token.balanceOf(o)
    assert.equal(balanceBefore_organizer, 1)

    // Transfer some coins
    await token.transfer(o, 10)

    // Validate after balance
    let balanceAfter_organizer = await token.balanceOf(accounts[1])
    assert.equal_organizer(balanceAfter, 11)

    await token.transfer(p, 10)
    let ba2 = await token.balanceOf(p)
    assert.equal(ba2, 10)


    await token.transfer(p2, 10)
    let ba3 = await token.balanceOf(p2)
    assert.equal(ba3, 10)


    await token.transfer(p3, 10)
    let ba4 = await token.balanceOf(p3)
    assert.equal(ba4, 10)


*/

})

})

})

})

