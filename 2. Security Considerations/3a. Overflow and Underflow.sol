pragma solidity 0.5.12;

contract underflow {
    
    uint8 n = 0;

    function subtract() public returns (uint8) {
        n = n - 1;
        return n; //underflow : n = 255
    }

}

contract overflow {
    
    uint8 n = 255;

    function add() public returns (uint8) {
        n = n + 1;
        return n; //overflow : n = 0
    }
}

/* To solve this problem we need to use SafeMath.sol Library */ 
//Like the below: 

pragma solidity 0.5.12;

import "SafeMath.sol"; 

contract underflow {

    using SafeMath for uint256; 
    
    uint256 n = 0;

    function subtract() public returns (uint256) {
        n = n.sub(1);
        return n; //underflow : n = 255 // Will throw an error
        }
contract overflow {

    using SafeMath for uint256; 
    
    uint256 n = 255;
    function add() public returns (uint256) {
        n = n.add(1);
        return n; //underflow : n = 0 // Will throw an error
        }

}

