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
    assert.equal(symbol, 'LOTT')

    let name = await token.name()
    assert.equal(name, 'TutorialToken')

    let decimals = await token.decimals()
    assert.equal(decimals, 1)



// p= 1st participant, p2 = 2nd participant, o = organizer, t = trigger
    let o = accounts[1]
    let p = accounts[2]
    let t = accounts[3]
    let p2 = accounts[4]
    let p3 = accounts[5]

//now lets transfer 10 coins to all accounts so that they are set up for the contest 

    // Verify the before balance
    let balanceBefore = await token.balanceOf(o)
    assert.equal(balanceBefore, 0)

    // Transfer some coins
    await token.transfer(o, 10)

    // Validate after balance
    let balanceAfter = await token.balanceOf(accounts[1])
    assert.equal(balanceAfter, 10)

    await token.transfer(p, 10)
    let ba2 = await token.balanceOf(p)
    assert.equal(ba2, 10)


    await token.transfer(p2, 10)
    let ba3 = await token.balanceOf(p2)
    assert.equal(ba3, 10)


    await token.transfer(p3, 10)
    let ba4 = await token.balanceOf(p3)
    assert.equal(ba4, 10)

// lets organize our first contest - o is our first organizer
// organize contest and seed with 7 tokens, but participants must contribute 5 tokens each 
    await token.approve( lto.address , 7 , {from: o})
    await lto.Organize(30,5,t,7, {from: o})


// lets organize our second contest - p3 is our second organizer
// organize contest and seed with 7 tokens, but participants must contribute 5 tokens each 
    await token.approve( lto.address , 2 , {from: p3})
    await lto.Organize(30,1,t,2, {from: p3})

//now lets participate
// 1st participant participate in 1st contest with 5 tokens so has 5 (10 intial - 5 contibuted) left 
    await token.approve( lto.address , 5 , {from: p})
    await lto.Participate ( 5 , o, {from :p})


// 1st participant participate in 2nd contest with 1 tokens so has 4 (10 intial - 5 contibuted -1 contributed) left 
    await token.approve( lto.address , 1 , {from: p})
    await lto.Participate ( 1 , p3, {from :p})


// 2nd participant participate in 1st contest with 5 more tokens, has 5 tokens left
   await token.approve( lto.address , 5 , {from: p2})
   await lto.Participate ( 5 , o, {from :p2})


// 2nd participant participate in 2nd contest with 1 more tokens, has 4 tokens left
    await token.approve( lto.address , 1 , {from: p2})
    await lto.Participate ( 1 , p3, {from :p2})



// 3rd participant participate with 5 more tokens, has 5 tokens left
   await token.approve( lto.address , 5 , {from: p3})
   await lto.Participate ( 5 , o, {from :p3})

    let nump = await lto.num_participants(o)
    let fmtp = new BigNumber(nump).toString()
//    assert.equal(nump, 2)
    console.log('1st contest num participants ', fmtp)

    let pamt= await lto.getpo(o)
    let fmt = new BigNumber(pamt).toString()

// 1st contest = 7 seed  tokens+ 3 participants * 5 tokens each = 22 tokens
    assert.equal(fmt, 22)
    console.log('1st contest pool amount', fmt)



    let nump2 = await lto.num_participants(p3)
    let fmtp2 = new BigNumber(nump2).toString()
//    assert.equal(nump2, 2)
    console.log('2nd contest num participants ', fmtp2)

    let pamt2= await lto.getpo(p3)
    let fmt3 = new BigNumber(pamt2).toString()

// 2nd contest = 2 seed  tokens+ 1 participants * 1 tokens each = 4 tokens
    assert.equal(fmt3, 4)
    console.log('2nd contest pool amount', fmt3)


/*
    let tri = await lto.gettri()
//    console.log('trigger address', tri)
    assert.equal(t, tri)

    let win= await lto.dp(2,{from: t})
    console.log('winner address', win)
    console.log('Participant 1 ', p)
    console.log('Participant 2 ', p2)
    console.log('Participant 2 ', p3)

*/

// ok draw for 1st contest now


    let win= await lto.dp(1,o, {from: t})

    await lto.draw(1,o, {from: t})

    let winreport = await token.balanceOf(win)
    let fmt2 = new BigNumber(winreport).toString()
    console.log('1st contest winner total tokens', fmt2)

// wins 22 tokens + 4 leftover = 26

    assert.equal(fmt2,26);

// ok draw for 2nd contest now
// lucky guy - wins both contests !!!!

    let win2= await lto.dp(0,p3, {from: t})

    await lto.draw(0, p3, {from: t})

    let winreport2 = await token.balanceOf(win2)
    let fmt4 = new BigNumber(winreport2).toString()
    console.log('2nd contest winner total tokens', fmt4)

// wins 4 tokens + 4 leftover = 8

    assert.equal(fmt4,8);

  })
})


})
