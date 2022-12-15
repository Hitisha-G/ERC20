// SPDX-License-Identifier: Unlicensed 

pragma solidity ^0.8.9;

contract MYDCoinERC20 {

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    string public constant name = "MAYDAYY";
    string public constant symbol = "MYD";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply;
    address owner;
    bool M_state;
    bool B_state;

    constructor(uint256 _total) {
      owner = msg.sender;
      totalSupply = _total;
      balances[msg.sender] = totalSupply;
    }

    modifier OnlyOwner{
        require(msg.sender==owner);
        _;
    }

    function total_Supply() public view returns(uint256) {
      return totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
             
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public OnlyOwner returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address _owner, address delegate) public view returns (uint) {
        return allowed[_owner][delegate];
    }

    function transferFrom(address _owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[_owner]);
        require(numTokens <= allowed[_owner][msg.sender]);

        balances[_owner] -= numTokens;
        allowed[_owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(_owner, buyer, numTokens);
        return true;
    }

    //owner can Disable or Enable the minting process
    function handle_mint(bool _state) public OnlyOwner
    {
        M_state= _state;
    }

    // owner can Disable or Enable burning process
    function handle_burn(bool _state) public OnlyOwner
    {
        B_state= _state;
    }

    function mint(uint _numToken) public 
    {
        require(M_state == true);
        balances[msg.sender]+= _numToken;
        totalSupply+=_numToken;
    }

    function burn(uint numToken) public {
        require(B_state == true);
        balances[msg.sender]-=numToken;
        totalSupply-=numToken;
    }

    function TrasnferOwner(address new_owner) public OnlyOwner returns(address) 
    {
        owner=new_owner;
        return (new_owner);
    }
}
