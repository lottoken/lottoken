pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/StandardToken.sol";

/* A single organizer address cannot have more than 1 contest running simulatenously */
/* A single winner of each contest */
/* need to clean up after contest ends */
/* Need to port to SafeMath */

contract Lotto {


struct one_lot {
    address organizer;  // person owning this contract and organizing uint
    address trigger; // person drawing the random numbers and triggering the lotto drawing

// amount of micro-Lottokens (1 Lottoken = 1000000 micro-Lottokens) each participant should provide
    uint contribution_req;

// Span of open period in micro seconds since the Lotto contract creation  to let participants join
    uint hold_time;


// lotto pool amount in micro-Lottokens
    uint pool_amount;

// winner after the Lotto draw 
    address winner;

    address[] participants ;

// time when this Lotto was created
    uint creation_time;


}

mapping (address => one_lot) public all_lot;

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
    
    all_lot[msg.sender].organizer = msg.sender;
    all_lot[msg.sender].hold_time = lotto_hold_time;
    all_lot[msg.sender].contribution_req = participant_contribution;
    all_lot[msg.sender].trigger = lotto_trigger;
    all_lot[msg.sender].pool_amount += organizer_contrib;
    
    // Transfer organizer_contrib from the organizer wallet to the contract

    lottok.transferFrom(msg.sender,this, organizer_contrib);

}

// Participate in the Lotto
// Have to contribute a minimum of contribution_req but can contribute more 
// Contributing more than the minimum required does not improve your odds

function Participate(uint contribution, address org) public returns (uint) {

    require(lottok.allowance(msg.sender, this) >= contribution);
    require(all_lot[org].pool_amount > 0 );
    require(contribution >= all_lot[org].contribution_req);
    
// Transfer contribution from the participant

    lottok.transferFrom(msg.sender,this, contribution);

    all_lot[org].pool_amount += contribution;
    all_lot[org].participants.push(msg.sender);
    return all_lot[org].participants.length;
}

// returns number of participants currently in the Lotto 
function num_participants(address org) public constant returns (uint) {
    return all_lot[org].participants.length;
}

function getpo(address org) public constant returns (uint) {
    return all_lot[org].pool_amount;
}

//get organizer address

function getoa(address org) public constant returns (address) {
    return all_lot[org].organizer;
}

function gettri(address org) public constant returns (address) {
    return all_lot[org].trigger;
}



// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 
function draw(uint random_number, address org) public {
    require(all_lot[org].pool_amount >0);
    require (msg.sender == all_lot[org].trigger);
//    require ( (random_number >=0) && (random_number < (participants.length -1)));

    address winner = all_lot[org].participants[random_number];

    //TBD transfer "pool_amount" funds to winner 

//lottok.transferFrom(this, winner , pool_amount);
lottok.transfer(winner , all_lot[org].pool_amount);

 //  return winner;

}



// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 
function dp(uint random_number, address org) public constant returns (address) {

    require(all_lot[org].pool_amount > 0 );
    require (msg.sender == all_lot[org].trigger);

//    require ( (random_number >=0) && (random_number < (participants.length -1)));

    address winner = all_lot[org].participants[random_number];

return winner;

    //TBD transfer "pool_amount" funds to winner 
//lottok.transferFrom(this, winner , pool_amount);

}

}

