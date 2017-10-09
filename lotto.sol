pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/StandardToken.sol";

contract Lotto {

address[] public participants;
address public organizer;  // person owning this contract and organizing uint
address public trigger; // person drawing the random numbers and triggering the lotto drawing

// amount of micro-Lottokens (1 Lottoken = 1000000 micro-Lottokens) each participant should provide
uint public contribution_req;

// Span of open period in micro seconds since the Lotto contract creation  to let participants join
uint public hold_time;

// time when this Lotto was created
uint creation_time;

// lotto pool amount in micro-Lottokens
uint public pool_amount;

// winner after the Lotto draw 
address winner;

// address of deployed token contract
address public LOTaddress ;
StandardToken public lottok;

//sta = set token address
function set_sta(address tok_addr) public 
{
    lottok = StandardToken(tok_addr);
    LOTaddress = tok_addr;
}

function get_sta() public constant returns (address)
{
    return LOTaddress;
}

// Organize a Lotto and set various parameters of the Lotto 
// organizer_contrib: Contribution in micro-Lottokens from the organizer towards the Lotto

function Organize(uint lotto_hold_time, uint participant_contribution, address lotto_trigger, uint256 organizer_contrib) public 
{
    require(lottok.allowance(msg.sender, this) >= organizer_contrib);
    
    organizer = msg.sender;
    hold_time = lotto_hold_time;
    contribution_req = participant_contribution;
    trigger = lotto_trigger;
    pool_amount += organizer_contrib;
    
    // Tying all this with solidity
    // Transfer organizer_contrib from the organizer wallet to the contract

    lottok.transferFrom(organizer,this, organizer_contrib);

}

// Participate in the Lotto
// Have to contribute a minimum of contribution_req but can contribute more 
// Contributing more than the minimum required does not improve your odds

function Participate(uint contribution) public returns (uint) {
    require(lottok.allowance(msg.sender, this) >= contribution);
    require(contribution >= contribution_req);

// Transfer contribution from the participant
    lottok.transferFrom(msg.sender,this, contribution);

    pool_amount += contribution;
    participants.push(msg.sender);
    return participants.length;

}

// returns number of participants currently in the Lotto 
function num_participants() public constant returns (uint) 
{
    return participants.length;
}

function getpo() public constant returns (uint) 
{
    return pool_amount;
}

function getoa() public constant returns (address) 
{
    return organizer;
}

function gettri() public constant returns (address) 
{
    return trigger;
}



// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 

function draw(uint random_number) public 
{
    require (msg.sender == trigger);
    require ( (random_number >=0) && (random_number < (participants.length)));

    winner = participants[random_number];

    //transfer "pool_amount" funds to winner 
    lottok.transfer(winner , pool_amount);

}



// Test function for winner selection
function dp(uint random_number) public constant returns (address) 
{
    require (msg.sender == trigger);

//    require ( (random_number >=0) && (random_number < (participants.length -1)));

    winner = participants[random_number];
    return winner;

}

}

