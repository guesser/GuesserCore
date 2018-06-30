pragma solidity 0.4.24;

//Internal
import "./TermsContract.sol";
// External
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";


/**
 * The Bet Terms contract is in charge of storing the basic information of the event
 * to function in time. This contract is the one that will ask if participation in an event is
 * still allowed, and, in case it is time, to allow the Oracle to ask for the information
 * and give the permision to return the profits to the Bet Token hodlers.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet terms. */
contract BetTerms is Pausable {
    using SafeMath for uint;

    TermsContract internal termsContract;
    bytes32 public termsHash;
    uint public initialBlock;

    constructor(address _termsContract, bytes32 _termsHash) public {
        termsContract = TermsContract(_termsContract);
        termsHash = _termsHash;
        initialBlock = block.number;
    }

    /**
     * @dev Function that returns the address of the Terms Contract of the event
     * @return address the address of the Terms Contract it relates to
     */
    function getTermsContractAddress() public view returns(address) {
        return address(termsContract);
    }

    /**
     * @dev Function that asks the TermsContract if playing is allowd
     * @return bool if it is the period for playing
     */
    function participationPeriod()
        internal
        view
        returns(bool)
    {
        return termsContract.participationPeriod(termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if it is the time to ask for the profits
     * @return bool if the period for betting is over
     */
    function retrievingPeriod()
        internal
        view
        returns(bool)
    {
        return termsContract.retrievingPeriod(termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if the event has finished
     * @return bool if the event is over
     */
    function finishedPeriod()
        internal
        view
        returns(bool)
    {
        return termsContract.finishedPeriod(termsHash);
    }
}
