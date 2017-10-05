pragma solidity ^0.4.4;

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

// Organize a Lotto and set various parameters of the Lotto 
// organizer_contrib: Contribution in micro-Lottokens from the organizer towards the Lotto
function Lotto(uint lotto_hold_time, uint participant_contribution, address lotto_trigger, uint organizer_contrib) public 
{
    organizer = msg.sender;
    hold_time = lotto_hold_time;
    contribution_req = participant_contribution;
    trigger = lotto_trigger;
    pool_amount += organizer_contrib;
    
    // TBD: Tying all this with solidity
    // TBD: Transfer organizer_contrib from the organizer wallet to the contract
    // TBD: Initialize participant array????
}

// Participate in the Lotto
// Have to contribute a minimum of contribution_req but can contribute more 
// Contributing more than the minimum required does not improve your odds
function participate(uint contribution) public returns (uint) {
    require(contribution >= contribution_req);
    // TBD: Transfer contribution from the participant
    pool_amount += contribution;
    participants.push(msg.sender);
    return participants.length;
}

// returns number of participants currently in the Lotto 
function num_participants() public constant returns (uint) {
    return participants.length;
}

// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 
function draw(uint random_number) public {
    require (msg.sender == trigger);
    require (random_number >=0 && random_number < (participants.length -1));
    winner = participants[random_number];
    //TBD transfer "pool_amount" funds to winner 
}

}
