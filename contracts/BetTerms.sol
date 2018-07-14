pragma solidity 0.4.24;

//Internal
import "./ProxyInterfaces/BetTermsProxyInterface.sol";
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
     * @param _termsProxy address the address of the Proxy contract
     * @param _termsHash bytes32 the hash of the terms
     * @return bool if it is the period for playing
     */
    function participationPeriod(address _termsProxy, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return BetTermsProxyInterface(_termsProxy)
            .participationPeriod(_termsHash);
    }

    /**
     * @dev function that asks the termscontract if playing is in stand by
     * @param _termsProxy address the address of the Proxy contract
     * @param _termsHash bytes32 the hash of the terms
     * @return bool if it is the waiting period
     */
    function waitingPeriod(address _termsProxy, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return BetTermsProxyInterface(_termsProxy)
            .waitingPeriod(_termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if it is the time to ask for the profits
     * @param _termsProxy address the address of the Proxy contract
     * @param _termsHash bytes32 the hash of the terms
     * @return bool if the period for betting is over
     */
    function retrievingPeriod(address _termsProxy, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return BetTermsProxyInterface(_termsProxy)
            .retrievingPeriod(_termsHash);
    }

    /**
     * @dev Function that asks the TermsContract if the event has finished
     * @param _termsProxy address the address of the Proxy contract
     * @param _termsHash bytes32 the hash of the terms
     * @return bool if the event is over
     */
    function finishedPeriod(address _termsProxy, bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        return BetTermsProxyInterface(_termsProxy)
            .finishedPeriod(_termsHash);
    }

    function changePeriod(address _termsProxy, bytes32 _termsHash, uint _status)
        public
    {
        betRegistry.isAuthorised(msg.sender);
        BetTermsProxyInterface(_termsProxy)
            .changePeriod(_termsHash, _status);
    }
}
