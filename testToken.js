/* global artifacts, contract, it, assert */
var BigNumber = require('bignumber.js')
var TutorialToken = artifacts.require('./TutorialToken.sol')
var Lotto = artifacts.require('./Lotto.sol')

const assertJump = require('./helpers/assertJump')


/**
 * Some sanity tests against the Zeppelin standard token contract
 */
contract('TutorialToken', (accounts) => {
  it('should deploy', () => {
    return TutorialToken.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Instance should not be null')
    })
  })


contract('Lotto', (accounts) => {
  it('should deploy', () => {
    return Lotto.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Lotto Instance should not be null')
    })
  })


  it('should have correct initial values set.', async () => {

    let token = await TutorialToken.deployed()


    let lto = await Lotto.deployed()

    // set token address to the deployed token's address

    await lto.set_sta(token.address)

    let results = await lto.get_sta()

    assert.equal(token.address, results)

    //console.log('tok addr',token.address)
    //console.log('results', results)


    let totalSuppy = await token.totalSupply()
    assert.equal(new BigNumber(totalSuppy).toString(), new BigNumber(13000).toString(), 'Initial supply should be 13 Thousand')

    let symbol = await token.symbol()
    assert.equal(symbol, 'MOTT')

    let name = await token.name()
    assert.equal(name, 'TutorialToken')

    let decimals = await token.decimals()
    assert.equal(decimals, 1)

    // Verify the before balance
    let balanceBefore = await token.balanceOf(accounts[1])
    assert.equal(balanceBefore, 0)

    // Transfer some coins
    await token.transfer(accounts[1], 10)

    // Validate after balance
    let balanceAfter = await token.balanceOf(accounts[1])
    assert.equal(balanceAfter, 10)


// p= 1st participant, p2 = 2nd participant, o = organizer, t = trigger
    let p = accounts[2]
    let o = accounts[1]
    let t = accounts[3]
    let p2 = accounts[4]
    let p3 = accounts[5]

//now lets transfer 10 coins to all accounts so that they are set up for the contest 

    await token.transfer(p, 10)
    let ba2 = await token.balanceOf(p)
    assert.equal(ba2, 10)


    await token.transfer(p2, 10)
    let ba3 = await token.balanceOf(p2)
    assert.equal(ba3, 10)


    await token.transfer(p3, 10)

// lets organize our first contest
// organize contest and seed with 7 tokens, but participants must contribute 5 tokens each 
    await token.approve( lto.address , 7 , {from: o})
    await lto.Organize(30,5,t,7, {from: o})


//now lets participate
// 1st participant participate with 5 tokens so has 5 (10 intial - 5 contibuted) left 
    await token.approve( lto.address , 5 , {from: p})
    await lto.Participate ( 5 , {from :p})


// 2nd participant participate with 5 more tokens, has 5 tokens left
   await token.approve( lto.address , 5 , {from: p2})
   await lto.Participate ( 5 , {from :p2})


   await token.approve( lto.address , 5 , {from: p3})
   await lto.Participate ( 5 , {from :p3})


    let nump = await lto.num_participants()
    let fmtp = new BigNumber(nump).toString()
//    assert.equal(nump, 2)
    console.log('num participants', fmtp)

    let pamt= await lto.getpo()
    let fmt = new BigNumber(pamt).toString()

// organizer = 7 seed  tokens+ 2 participants * 5 tokens each
//    assert.equal(fmt, 17)
    console.log('pool amount', fmt)

    let tri = await lto.gettri()
//    console.log('trigger address', tri)
    assert.equal(t, tri)

    let win= await lto.dp(2,{from: t})
    console.log('winner address', win)
    console.log('Participant 1 ', p)
    console.log('Participant 2 ', p2)
    console.log('Participant 2 ', p3)

// ok draw now

    await lto.draw(2,{from: t})

    let winreport = await token.balanceOf(win)
    let fmt2 = new BigNumber(winreport).toString()
    console.log('winner total tokens', fmt2)

// wins 17 tokens + 5 leftover = 22

//    assert.equal(fmt2,22);


  })
})


})
