pragma solidity 0.4.24;

// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";


/**
 * Collateralized is the abstract contract for the different types of elements
 * that you can use to bet in the Guesser Protocol.
 * This contract will handle the manipulation of the different kind of collaterals
 * that the Guesser Protocol can use. 
 * By the moment the types supported are be:
 *  - ERC20 tokens
 *  - ERC721 tokens
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetPayments. */
contract BetPayments is Pausable {
    using SafeMath for uint;

    // Storage variables
    ERC721Token betToken;

    /**
     * @dev Modifier that checks if the sender is the Bet Token
     */
    modifier onlyBetToken() {
       require(address(betToken) == msg.sender);
        _;
    }

    function addBetToken (address _betToken)
        public
        onlyOwner
        whenNotPaused
    {
        betToken = ERC721Token(_betToken);
        pause();
    }

    /**
     * @dev Function that tells the balance of the bet
     * @return uint the balance of the user 
     */
    function balance() 
        public
        view
        returns(uint);

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
        returns(bool);
}
