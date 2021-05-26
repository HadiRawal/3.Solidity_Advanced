/******Debugging 1******/

/* There are 2 types of errors:
   1. Compiling Error: (syntax, typing errors) 
                      it shows when we compile the contract e.g. typing "unit" instead of "uint"
   2. Run Time Error: (logic, inputs, calculation errors)
                      it shows at the time of contract runing e.g. not having enough balance to transfer 
                      
   Probing & Debugging the errors (manually): 
   1. by commenting the lines one by one in the area that caused this error,in order to know the line that causes this error,
   2. then we need to check the logic in this line to find out the issue */

pragma solidity 0.7.5;
pragma abicoder v2;
import "./Ownable.sol";

interface GovermentInterface{
    function addTransaction(address _from, address _to, uint _amount) external payable;
}

contract Bank is Ownable {
    
    GovermentInterface govermentInstance = GovermentInterface(0xAc40c9C8dADE7B9CF37aEBb49Ab49485eBD3510d);
    
    mapping(address => uint) balance;
    
    event depositDone(uint amount, address indexed depositedTo);
    
    
    function deposit() public payable returns (uint)  {
        balance[msg.sender] = msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public onlyOwner returns (uint){
        require(balance[msg.sender] >= amount);
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }
    
    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public {
        //the error is within this function, therefore we can comment the below lines one by one until we find the error line.
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        govermentInstance.addTransaction(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount); // Error = invalid opcode (assert check failed)
    }
    
    function _transfer(address from, address to, uint amount) private {
        // fixing the "invalid opcode" error through fixing the below equations
        balance[from] - amount; //  balance[from] =  balance[from] - amount
        balance[to] + amount;   //  balance[to] =  balance[from] + amount
    }
      function getTransfers() external view returns(uint[] memory) {

    }
    
}
