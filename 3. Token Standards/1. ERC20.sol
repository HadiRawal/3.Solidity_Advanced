//*** ERC-20 ***//

/* What is ERC?:
   ERC20 standard was implemented in 2015-11-19 by Fabian Vogelsteller, Vitalik Buterin 
   https://eips.ethereum.org/EIPS/eip-20

   ERC is about Standardising the the functions of the tokens in order to ease the dealing with these different tokens
   by diffrent wallets and exchanges.
   A standard interface allows any tokens on Ethereum to be re-used by other applications: 
   from wallets to decentralized exchanges.

   *EIP stands for "Ethereum Improvement Proposals"
   *ERC stands for "Ethereum request for comment"
*/

/* Commenting Format in Solidity (NatSpec):
   Solidity contracts can use a special form of comments to provide rich documentation for functions, 
   return variables and more. 
   This special form is named the Ethereum Natural Language Specification Format (NatSpec).

     Tag	 	        Description                                                         Context
    @title	 A title that should describe the contract/interface	                 contract, interface
    @author	 The name of the author	                                                 contract, interface, function
    @notice	 Explain to an end user what this does	                                 contract, interface, function
    @dev	 Explain to a developer any extra details	                             contract, interface, function
    @param	 Documents a parameter just like in doxygen (followed by pareter name)   function
    @return	 Documents the return type of a contract’s function	                     function
    
    https://docs.soliditylang.org/en/v0.5.12/natspec-format.html
*/
pragma solidity 0.8.0;

//@title ERC20 standard token implementation.
//@dev Standard ERC20 token. This contract follows the implementation at https://goo.gl/mLbAPJ.

contract Token {
  //Token name.
  string internal tokenName;
  //Token symbol.
  string internal tokenSymbol;
  //Number of decimals.
  uint8 internal tokenDecimals;
  //Total supply of tokens.
  uint256 internal tokenTotalSupply;
  //Balance information map.
  mapping (address => uint256) internal balances;
  //Token allowance mapping.
  mapping (address => mapping (address => uint256)) internal allowed;
  //@dev Trigger when tokens are transferred, including zero value transfers.
  event Transfer(address indexed _from,address indexed _to,uint256 _value);
  //@dev Trigger on any successful call to approve(address _spender, uint256 _value).
  event Approval(address indexed _owner,address indexed _spender,uint256 _value);
  
  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _initialOwnerBalance) {
      tokenName = _name;
      tokenSymbol = _symbol;
      tokenDecimals = _decimals;
      tokenTotalSupply = _initialOwnerBalance;
      balances[msg.sender] = _initialOwnerBalance;
  }

  //@dev Returns the name of the token - e.g. "MyToken".
  function name() external view returns (string memory _name){
    _name = tokenName;
  }

  //@dev Returns the symbol of the token. E.g. “HIX”.
  function symbol() external view returns (string memory _symbol){
    _symbol = tokenSymbol;
  }

  /*@dev Returns the number of decimals the token uses - 
         e.g. 8, means to divide the token amount by 100000000 to get its user representation.*/
  function decimals() external view returns (uint8 _decimals){
    _decimals = tokenDecimals;
  }

  // @dev Returns the total token supply.
  function totalSupply()external view returns (uint256 _totalSupply){
    _totalSupply = tokenTotalSupply;
  }

  //@dev Returns the account balance of another account with address _owner.
  //@param _owner The address from which the balance will be retrieved.
  function balanceOf(address _owner) external view returns (uint256 _balance){
    _balance = balances[_owner];
  }

  /*@dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
    The function SHOULD throw if the "from" account balance does not have enough tokens to spend.*/
  //@param _to The address of the recipient.
  //@param _value The amount of token to be transferred.
  function transfer(address payable _to, uint256 _value) public returns (bool _success){
    require(balances[msg.sender] >= _value);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    _success = true;
  }

  /*@dev Allows _spender to withdraw from your account multiple times, up to the _value amount. 
    If this function is called again it overwrites the current allowance with _value. SHOULD emit the Approval event.*/
  //@param _spender The address of the account able to transfer the tokens.
  //@param _value The amount of tokens to be approved for transfer.
  function approve(address _spender,uint256 _value) public returns (bool _success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    _success = true;
  }

  //@dev Returns the amount which _spender is still allowed to withdraw from _owner.
  //@param _owner The address of the account owning tokens.
  //@param _spender The address of the account able to transfer the tokens.
  function allowance(address _owner,address _spender) external view returns (uint256 _remaining){
    _remaining = allowed[_owner][_spender];
  }

  //@dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
  //@param _from The address of the sender.
  //@param _to The address of the recipient.
  //@param _value The amount of token to be transferred.
  function transferFrom(address _from,address _to,uint256 _value) public returns (bool _success){
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] -= _value;
    balances[_to] += _value;
    allowed[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);
    _success = true;
  }

}