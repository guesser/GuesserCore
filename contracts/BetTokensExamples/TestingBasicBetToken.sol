pragma solidity 0.4.24;

// Internal
import "../BetToken.sol";


/**
 * This is a skull around the Bet Token to make the basic test of other
 * contracts easier. 
 * DO NOT USE THIS CONTRACT FOR MORE THAN TESTING!
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet Token. */
contract TestingBasicBetToken is BetToken {

    constructor (
        address _oracle,
        address _collateral,
        address _termsContract,
        bytes32 _termsHash
    )
    public
    BetToken(
        _oracle,
        _collateral,
        _termsContract,
        _termsHash
    ) {}

    function transferFrom(
        address _from,
        address _to,
        uint _amount
    ) public 
    onlyOwner {
        paymentsContract.transferFrom(_from, _to, _amount);
    }
}
