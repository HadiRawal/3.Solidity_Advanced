//***Extend the Token from openZeppelin ERC20Capped***//
// Total Supply & Ownership //

pragma solidity 0.8.0;

//import openZeppelin-ERC20Capped & Ownable Library 
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";


//inherit ERC20 from openZeppelin-ERC20Capped
/* Note: ERC20Capped is already inherited from ERC20, so we can inherit from the child 
         only and consequently will inherit from the parent.
         The same is applicable for Ownable(extra features in addation to the parent features*/
contract HanaToken is ERC20Capped, Ownable {
        
        //inherit OpenZeppelin-ERC20 constructor (Token Name & Symbol)
        //inherit OpenZeppelin-ERC20Capped constructor (Total Supply)
        //The Token Name is HanaToken, The Token symbol is "HNAT"
        //for constructor we have to inherit separately from both files
        constructor() ERC20("HanaToken", "HNAT") ERC20Capped(100000) {
                //adding Balance of this Token by minting
                _mint(msg.sender, 1000);
        }

}