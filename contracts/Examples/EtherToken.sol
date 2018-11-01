pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";


contract EtherToken is MintableToken, BurnableToken {

    function buy() public payable {
        mint(msg.sender, msg.value);
    }

    function sell(uint256 amount) public {
        burn(amount);
        msg.sender.transfer(amount);
    }
}
