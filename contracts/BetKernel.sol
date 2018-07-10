pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./BetPayments.sol";
import "./BetOracle.sol";
import "./BetTerms.sol";


/**
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetKernel. */
contract BetKernel is RegistrySetter {

    /**
     * @dev Function adds a bet from a player to a bet
     * @param _betHash bytes32 of the bet you want to get
     * @param _option uint the choosen option by the player
     * @param _amount uint the quantity of tokens bet
     * @return bool if the betting was succesfull
     */
    function placeBet(
        bytes32 _betHash,
        uint _option,
        uint _amount
    )
        public
        whenPaused
        returns(bytes32)
    {
        address _paymentsProxy;
        address _paymentsToken;
        _paymentsProxy = betRegistry.getBetPaymentsProxy(_betHash);
        _paymentsToken = betRegistry.getBetPaymentsToken(_betHash);

        BetPayments _betPayments = BetPayments(betRegistry.betPayments());
        BetTerms _betTerms = BetTerms(betRegistry.betTerms());
        require(
            _betTerms.participationPeriod(
                betRegistry.getBetTermsProxy(_betHash),
                betRegistry.getBetTermsHash(_betHash)
            )
        );

        require(
            _betPayments.transferFrom(
                _paymentsProxy,
                _paymentsToken,
                msg.sender,
                address(_betPayments),
                _amount
            )
        );
        // Creating the actual bet and returning the hash
        return betRegistry.placeBet(
            _betHash,
            msg.sender,
            _option,
            _amount
        );
    }

    /**
     * @dev Function that ask for the profits of a user
     * @param _betHash bytes32 the hash of the bet
     * @param _playerBetHash bytes32 the hash of the game bet the player played
     * @return bool if returning profits was succesfull
     */
    function getProfits(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        returns(uint)
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
            return 0;

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
        // Return the money
        require(
            _betPayments.transfer(
                betRegistry.getBetPaymentsProxy(_betHash),
                betRegistry.getBetPaymentsToken(_betHash),
                msg.sender,
                _profits
            )
        );
        betRegistry.setPlayerBetReturned(_betHash, _playerBetHash, true);
        return _profits;
    }
}
