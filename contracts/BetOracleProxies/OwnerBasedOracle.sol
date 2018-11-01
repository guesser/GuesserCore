pragma solidity ^0.4.24;

// Internal
import "../ProxyInterfaces/BetOracleProxyInterface.sol";
import "../RegistrySetter.sol";


/**
 * A contract that creates an Oracle proxy that is based on the owner
 * knowledge for the outcome resolution.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title OwnerBasedOracle. */
contract OwnerBasedOracle is RegistrySetter, BetOracleProxyInterface {

    mapping(bytes32 => bool) private betReady;
    mapping(bytes32 => uint) private betOutcome;

    /**
     * @dev Function that returns if the oracle is ready to return the outcome
     * @param _betHash bytes32 the hash of the bet we are asking for
     * @return bool if the outcome is ready to get it
     */
    function outcomeReady(
        bytes32 _betHash
    )
        public
        view
        returns(bool)
    {
        return betReady[_betHash];
    }

    /**
     * @dev Function that returns the outcome of the bet
     * @param _betHash bytes32 the hash of the bet we are asking for
     * @return uint the outcome of the bet
     */
    function getOutcome(
        bytes32 _betHash
    )
        public
        view
        returns(uint)
    {
        require(outcomeReady(_betHash));

        return betOutcome[_betHash];
    }

    /**
     * @dev Function that sets if the outcome of a bet is ready
     * @param _betHash bytes32 the hash of the bet we are asking for
     */
    function setOutcomeReady(
        bytes32 _betHash,
        bool _ready
    )
        public
        onlyOwner
    {
        betReady[_betHash] = _ready;
    }

    /**
     * @dev Function that sets the outcome of a bet
     * @param _betHash bytes32 the hash of the bet we are asking for
     */
    function setOutcome(
        bytes32 _betHash,
        uint _outcome
    )
        public
        onlyOwner
    {
        betOutcome[_betHash] = _outcome;
    }
}
