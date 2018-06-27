pragma solidity 0.4.24;

// Internal
import "../BetPayments.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
 * An ERC20 implementation for the payments used in the Guesser Protocol
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetPayments. */
contract ERC20Payment is BetPayments {

    // Storage variables
    ERC20 paymentToken;

    constructor (address _token) public {
        paymentToken = ERC20(_token);
    }

    /**
     * @dev Function that tells the balance of the bet
     * @return uint the balance of the user 
     */
    function balance() 
        public
        view
        returns(uint) 
    {
        return betToken.balanceOf(address(this));
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _to address Address of the beneficiary
     * @param _profit uint this will depend in the child token if it is 
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transfer(address _to, uint _profit) 
        public
        whenPaused
        onlyBetToken
        returns(bool)
    {
      // Requires handled by the bet Token
      paymentToken.transferFrom(address(this), _to, _profit);
      return true;
    }
}
