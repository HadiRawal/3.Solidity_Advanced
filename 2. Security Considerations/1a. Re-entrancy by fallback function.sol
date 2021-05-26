//****Re-entrancy attack through a fallback function****//
/*This attack happens when a call back built in a way that allows the other contract to re-enter the function 
  to execute it again and again before setting the balance to zero */
  
/*Example of unsecured structure of a Victim contract to re-entrance attack:*/

contract VictimContrcat {  
    mapping (address => uint) balance;
    
    function WithdrawVictimFunction() public {
        require(balance [msg.sender] > 0);     //1.CHECKS : Requirements are valid ??
        msg.sender.send(balance[msg.sender]);  //2.INTERACTIONS : execute the task  
                                                   //Attack would happen here by re-enter repeatedly and execute the withdrawal again and again before setting the contract to zero.
        balance[msg.sender] = 0;               //3.EFFECTS: setting the contract after the execution
    }

//therefore the pattern (CHECKS-INTERACTIONS-EFFECTS) is unsafe. 
//the Secured Pattern (order) is (CHECKS-EFFECTS-INTERACTIONS)

/*Example of secured structure of a Victim contract to re-entrance attack:*/

contract SafePatternContract {  // With send Function (EIP1884)
    mapping (address => uint) balance;
    
    function WithdrawFunction() public {
        require(balance [msg.sender] > 0);           //1.CHECKS : Requirements are valid ??
        uint toTrnasfer = balance[msg.sender];          //to set the balance(msg.sender) to zero, we need to move the balance to temp Variable.
        balance[msg.sender] = 0;                     //2.EFFECTS: setting the contract before the execution
        bool sucess = msg.sender.send(toTransfer);   //3.INTERACTIONS : execute the task  
        /*The Solution is in this order because:
                        the hacker can't loop in the send function as we set balance(msg.sender) to zero before the excution.*/
        // If the sending is not successful, we need to reset the balance
        if(!success) {
            balance [msg.sender] = toTransfer;
        }
    }
    
/* there are 3 functions to send fund :
   EIP1884 (limited gas stipend:2300)
   1. send function : (has only 2300 gas stipend to execute once only) 
   2. transfer function : (has only 2300 gas stipend)
   EIP1884 cons: what if the operation cost changed (up or down) in the future, then EIP1884 functions will not help  

   Traditional (unlimited gas stipend)
   3. call function  - we can use only with the above pattern (CHECKS, EFFECTS ,INTERACTIONS)*/

contract SafePatternContract {  // With call Function (best practice)
    mapping (address => uint) balance;
    
    function WithdrawFunction() public {
        require(balance [msg.sender] > 0);                          //1.CHECKS    
        uint toTrnasfer = balance[msg.sender];          
        balance[msg.sender] = 0;                                    //2.EFFECTS            
        (bool sucess,) = msg.sender.call{value: toTransfer}("");    //3.INTERACTIONS 
        if(!success) {
            balance [msg.sender] = toTransfer;
        }
    }

