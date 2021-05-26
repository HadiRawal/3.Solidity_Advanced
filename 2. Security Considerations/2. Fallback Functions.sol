

contract VictimBank {  //unsafe Pattern

    mapping(address => uint) balance;

    function Victim_Withdraw () public {   
        require(balance[msg.sender] > 0 ); //Checks
        msg.sender.send(balance[msg.sender]); //Interactions
        balance[msg.sender] = 0; //Effects
    }
}


contract Attack {

    function start() public {
        //deposit funds to VictimBank
        //call to withdraw();
    }

    //calls with no data

    receive() external payable{  //Fallback Function
        //new call to withdraw ---- here the loop starts
    }
}