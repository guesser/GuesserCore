pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./ProxyInterfaces/BetOracleProxyInterface.sol";


/**
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet Oracle. */
contract BetOracle is RegistrySetter {

    /**
     * @dev Function that returns if the oracle is ready to return the outcome
     * @param _proxy address Address of the proxy oracle
     * @param _betHash bytes32 the hash of the bet we are asking for
     * @return bool if the outcome is ready to get it
     */
    function outcomeReady(
        address _proxy,
        bytes32 _betHash
    )
        public
        view
        returns(bool)
    {
        return BetOracleProxyInterface(_proxy).outcomeReady(_betHash);
    }

    /**
     * @dev Function that returns the outcome of the bet
     * It will revert if the outcome is not ready
     * @param _proxy address Address of the proxy oracle
     * @param _betHash bytes32 the hash of the bet we are asking for
     * @return uint the outcome of the bet
     */
    function getOutcome(
        address _proxy,
        bytes32 _betHash
    )
        public
        view
        returns(uint)
    {
        require(outcomeReady(_proxy, _betHash));

        return BetOracleProxyInterface(_proxy).getOutcome(_betHash);
    }
}
