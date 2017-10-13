pragma solidity ^0.4.13;
import "zeppelin-solidity/contracts/token/StandardToken.sol";

contract LottoSale {

    address LOTaddress ;
    StandardToken lottok;
    address sale_owner;
    uint rate;


    //sta = set token address, token_rate = number of weis which one requires to buy one token
    function set_sta(address tok_addr, uint token_rate) public 
    {
        require(sale_owner == msg.sender);
        lottok = StandardToken(tok_addr);
        LOTaddress = tok_addr;
        rate = token_rate;
    }

    function get_sta() public constant returns (address)
    {
        return LOTaddress;
    }


    function LottoSale() {
        sale_owner = msg.sender;
    }

    function () payable{
        require (msg.value >= rate);
        require (msg.value % rate == 0);
        require (lottok.balanceOf(this) > (msg.value/rate));
        lottok.transfer(msg.sender, (msg.value/rate));
    }

    // end the sale and return back all the ether
    function finalize() public returns (uint) {
        require(sale_owner == msg.sender);

        // transfer tokens back to the owner
        lottok.transfer(sale_owner, lottok.balanceOf(this));

        // transfer all ethers back to the owner
        sale_owner.transfer(this.balance);

        // finish urself
        selfdestruct(this);
    }

}

