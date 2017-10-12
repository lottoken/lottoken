pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/StandardToken.sol";

/* A single organizer address cannot have more than 1 contest running simulatenously */
/* A single winner of each contest */
/* Need to port to SafeMath */

contract Lotto {

/* Generates a random number from 0 to 100 based on the last block hash */
function randomGen(uint seed, uint modulo) constant returns (uint) {
    return(uint(sha3(block.blockhash(block.number-1), seed )) % modulo);
}


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

// content running 
    bool contest_running;

// random draw
    uint draw;


}

mapping (address => one_lot) public all_lot;

address LOTaddress ;
StandardToken lottok;
address must_be_from;
bool is_first_time = true;

//sta = set token address
function set_sta(address tok_addr) public 
{
    if( is_first_time == true)
    {
	is_first_time = false;
        must_be_from = msg.sender;
    }
    require(must_be_from == msg.sender);
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


    require(all_lot[msg.sender].contest_running == false);
    require(lottok.allowance(msg.sender, this) >= organizer_contrib);
    require(participant_contribution > 0);
    require(lotto_hold_time > 0);
    require(organizer_contrib > 0);
    
    all_lot[msg.sender].contest_running = true;
    all_lot[msg.sender].organizer = msg.sender;
    all_lot[msg.sender].hold_time = lotto_hold_time;
    all_lot[msg.sender].contribution_req = participant_contribution;
    all_lot[msg.sender].trigger = lotto_trigger;
    all_lot[msg.sender].pool_amount = organizer_contrib;
    
    // Transfer organizer_contrib from the organizer wallet to the contract

    lottok.transferFrom(msg.sender,this, organizer_contrib);

}

// Participate in the Lotto
// Have to contribute a minimum of contribution_req but can contribute more 
// Contributing more than the minimum required does not improve your odds

function Participate(uint contribution, address org) public returns (uint) {

    require(lottok.allowance(msg.sender, this) >= contribution);
    //TBD check if there is a lottery record with "org"
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
    //TBD check if there is a lottery record with "org"
    return all_lot[org].participants.length;
}

function getpo(address org) public constant returns (uint) {
    //TBD check if there is a lottery record with "org"
    return all_lot[org].pool_amount;
}

//get organizer address

function getoa(address org) public constant returns (address) {
    //TBD check if there is a lottery record with "org"
    return all_lot[org].organizer;
}

function gettri(address org) public constant returns (address) {
    //TBD check if there is a lottery record with "org"
    return all_lot[org].trigger;
}



// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 
function draw(uint random_number, address org) public {

    require(all_lot[org].contest_running ==true);
    require(all_lot[org].pool_amount >0);
    require (msg.sender == all_lot[org].trigger);
    require ( (random_number >=0) && (random_number < (all_lot[org].participants.length)));

    address winner = all_lot[org].participants[random_number];

//transfer "pool_amount" funds to winner 

    lottok.transfer(winner , all_lot[org].pool_amount);

//clean up

    all_lot[org].contest_running = false;
    all_lot[org].participants.length = 0;
    all_lot[org].draw = randomGen(uint(msg.sender), uint(all_lot[org].participants.length));



}



// Draw the lottery and transfer funds to the winner
// random_number is between 0 and number of participants 
function dp(uint random_number, address org) public constant returns (address) {
    //TBD check if there is a lottery record with "org"
    require(all_lot[org].pool_amount > 0 );
    require (msg.sender == all_lot[org].trigger);
    require ( (random_number >=0) && (random_number < (all_lot[org].participants.length)));

    address winner = all_lot[org].participants[random_number];

    return winner;
}

}

