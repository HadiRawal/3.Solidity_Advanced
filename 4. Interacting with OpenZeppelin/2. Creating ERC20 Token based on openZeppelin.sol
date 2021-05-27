//***Creating ERC20 based on OpenZeppelin-ERC20***//
//Basic Features// 

pragma solidity 0.8.0;

//import openZeppelin-ERC20 Library
        /*in order to import openZeppelin Library:
                we need to install NPM (node package manager)
                On the Terminal type the following
                1. npm init
                2. truffe init
                3. npm install @openzeppelin/contracts

        */
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

//inherit ERC20 from openZeppelin
contract HanaToken is ERC20 {
        //inherit OpenZeppelin-ERC20 constructor
        //The Token Name is HanaToken, The Token symbol is "HNAT"
        constructor() ERC20("HanaToken", "HNAT") {
                //adding Balance of this Token by minting
                _mint(msg.sender, 1000);
        }

}