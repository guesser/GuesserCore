pragma solidity 0.4.24;

// Internal
import "../ProxyInterfaces/BetOracleProxyInterface.sol";
import "../RegistrySetter.sol";


/**
 * A contract that allows the bet owner to choose the outcome of an event
 * The main difference between this contract and the OwnerBasedOracle is that
 * in that one, all the bets outcomes are choosen by the creator of the oracle
 * and not the creator of the bet.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetOwnerBasedOracle. */
contract BetOwnerBasedOracle is RegistrySetter, BetOracleProxyInterface {

    mapping(bytes32 => bool) private betReady;
    mapping(bytes32 => uint) private betOutcome;

    modifier onlyBetOwner(bytes32 _betHash) {
        require(betRegistry.getBetCreator(_betHash) == msg.sender);
        _;
    }

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
        onlyBetOwner(_betHash)
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
        onlyBetOwner(_betHash)
    {
        betOutcome[_betHash] = _outcome;
    }
}
