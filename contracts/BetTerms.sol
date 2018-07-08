pragma solidity 0.4.24;

//Internal
import "./TermsContract.sol";
import "./RegistrySetter.sol";


/**
 * The Bet Terms contract is in charge of the basic information of the event
 * to function in time. This contract is the one that will ask if participation in an event is
 * still allowed, and, in case it is time, to allow the Oracle to ask for the information
 * and give the permision to return the profits to the Bet hodlers.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet Terms. */
contract BetTerms is RegistrySetter {

    /**
     * @dev function that asks the termscontract if playing is allowd
     * @return bool if it is the period for playing
     */
    function participationPeriod(address _termsContract, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return TermsContract(_termsContract).participationPeriod(_termsHash);
    }

    /**
     * @dev function that asks the termscontract if playing is in stand by
     * @return bool if it is the waiting period
     */
    function waitingPeriod(address _termsContract, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return TermsContract(_termsContract).waitingPeriod(_termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if it is the time to ask for the profits
     * @return bool if the period for betting is over
     */
    function retrievingPeriod(address _termsContract, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return TermsContract(_termsContract).retrievingPeriod(_termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if the event has finished
     * @return bool if the event is over
     */
    function finishedPeriod(address _termsContract, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return TermsContract(_termsContract).finishedPeriod(_termsHash);
    }
}
