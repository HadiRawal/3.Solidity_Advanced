/******Using Remix Debugger******/
/******Debugging Tools on Remix******/ 

/* Check the attached figure (Debugging 2 -Remix Debugging tools.png) */

//** Execution Steps:
/* 1. compile and deploy the contract
   2. deposit 500 wei , then deposit another 300 wei
   3. try to withdraw 600 wei, you will get an error
   4. click Debug down in the console*/

pragma solidity 0.7.5;
pragma abicoder v2;
import "./Ownable.sol";

contract Bank is Ownable {
    
    mapping(address => uint) balance;

    event depositDone(uint amount, address indexed depositedTo);
    
    function deposit() public payable returns (uint)  {
        balance[msg.sender] = msg.value;  /* 8. Find the Error: this function is writing the new deposit "300" over the previous one "500", 
                                                                Consequently,The balance is 300 instead of 800.*/
                                          // 9. Error Correction: balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
                                                                    //**Debugging Steps:   
    function withdraw(uint amount) public onlyOwner returns (uint){ //1. Debugger will highlight this function header, 2.check "Solidity State"
        require(balance[msg.sender] >= amount);                     //3. then choose this line as next breakpoint, 4.check "Solidity State"
        msg.sender.transfer(amount);                                //5. then choose this line as next breakpoint, 6.check "Solidity State".
        return balance[msg.sender];                                 //6. we will find the withdrawal amount is "500 wei "less than we entered "600 wei"
    }                                                               //7. we can conclude that the issue is in our deposit function  -check it out
    
    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }
    
    function transfer(address payable recipient, uint amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount);
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] = balance[from] - amount;
        balance[to] = balance[to] + amount;
    }
    
}