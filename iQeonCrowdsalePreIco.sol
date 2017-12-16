pragma solidity ^0.4.16;

interface token {
    function transfer(address receiver, uint amount);
}

contract Ownable {

    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
}

contract IQNPreICO is Ownable {
    
    uint256 public constant EXCHANGE_RATE = 700;
    uint256 public constant START = 1513425600; // Saturday, 16-Dec-17 12:00:00 UTC in RFC 2822



    uint256 availableTokens;
    address addressToSendEthereum;
    address addressToSendTokenAfterIco;
    
    uint public amountRaised;
    uint public deadline;
    uint public price;
    token public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool crowdsaleClosed = false;

    /**
     * Constrctor function
     *
     * Setup the owner
     */
    function IQNPreICO (
        address addressOfTokenUsedAsReward,
        address _addressToSendEthereum,
        address _addressToSendTokenAfterIco
    ) {
        availableTokens = 500000 * 10 ** 18;
        addressToSendEthereum = _addressToSendEthereum;
        addressToSendTokenAfterIco = _addressToSendTokenAfterIco;
        deadline = START + 9 days;
        tokenReward = token(addressOfTokenUsedAsReward);
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function () payable {
        require(now < deadline && now >= START);
        require(msg.value >= 3 ether);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        availableTokens -= amount;
        tokenReward.transfer(msg.sender, amount * EXCHANGE_RATE);
        addressToSendEthereum.transfer(amount);
    }

    modifier afterDeadline() { 
        require(now >= deadline);
        _; 
    }

    function sendAfterIco(uint amount)  public payable onlyOwner afterDeadline
    {
        tokenReward.transfer(addressToSendTokenAfterIco, amount);
    }
    
    function sellForBitcoin(address _address,uint amount)  public payable onlyOwner
    {
        tokenReward.transfer(_address, amount);
    }

    function tokensAvailable() public constant returns (uint256) {
        return availableTokens;
    }

}

"0x0db8d8b76bc361bacbb72e2c491e06085a97ab31","0xA3f4cB9D19586f4Abf1bccfF076804b2DE827216","0x0db8d8b76bc361bacbb72e2c491e06085a97ab31"  