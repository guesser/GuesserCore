pragma solidity 0.4.24;

// Internal
import "./ERC20BetKernelProxy.sol";
import "../WETH9.sol";

/**
 * A WETH implementation for the kernel used in the Guesser Protocol
 * It has to inherate from the RegistrySetter so it can get called throught
 * a delegate call from the BetPayments contract.
 *
 * Author: Ben Kaufman -- Github: ben-kaufman
 */
/** @title ETHBetKernelProxy. */
contract ETHBetKernelProxy is ERC20BetKernelProxy {
    /**
     * @dev Function that ask for the profits of a user
     * @param _betHash bytes32 the hash of the bet
     * @param _playerBetHash bytes32 the hash of the game bet the player played
     * @return uint the amount of tokens sent
     */
    function getProfits(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        returns(bool)
    {
        BetPayments _betPayments = BetPayments(betRegistry.betPayments());
        BetOracle _betOracle = BetOracle(betRegistry.betOracle());
        BetTerms _betTerms = BetTerms(betRegistry.betTerms());
        
        require(msg.sender == betRegistry.getPlayerBetPlayer(_betHash, _playerBetHash));
        require(!betRegistry.getPlayerBetReturned(_betHash, _playerBetHash));

        require(
            _betOracle.outcomeReady(
                betRegistry.getBetOracleProxy(_betHash),
                _betHash
            )
        );
        if (
            _betOracle.getOutcome(
                betRegistry.getBetOracleProxy(_betHash),
                _betHash
            ) != betRegistry.getPlayerBetOption(_betHash, _playerBetHash)
        ) 
            return false;

        require(
            _betTerms.retrievingPeriod(
                betRegistry.getBetTermsProxy(_betHash),
                betRegistry.getBetTermsHash(_betHash)
            )
        );
        uint _profits = betRegistry.getPrincipalInOption(
                _betHash,
                betRegistry.getPlayerBetOption(_betHash, _playerBetHash)
            ) / betRegistry.getPlayerBetPrincipal(_betHash, _playerBetHash);
        _profits = betRegistry.getTotalPrincipal(_betHash) / _profits;
        
        // Get the WETH tokens
        require(
            _betPayments.transfer(
                betRegistry.getBetPaymentsProxy(_betHash),
                betRegistry.getBetPaymentsToken(_betHash),
                address(this),
                _profits
            )
        );

        betRegistry.setPlayerBetReturned(_betHash, _playerBetHash, true);
        
        
        WETH9(betRegistry.getBetPaymentsToken(_betHash)).withdraw(_profits);
        // Return the ETH
        (msg.sender).transfer(_profits);
        

        return true;
    }
}
