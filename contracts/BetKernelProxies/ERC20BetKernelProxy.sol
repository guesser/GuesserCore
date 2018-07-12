pragma solidity 0.4.24;

// Internal
import "../ProxyInterfaces/BetKernelProxyInterface.sol";
import "../RegistrySetter.sol";
import "../BetPayments.sol";
import "../BetOracle.sol";
import "../BetTerms.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


/**
 * An ERC20 implementation for the kernel used in the Guesser Protocol
 * It has to inherate from the RegistrySetter so it can get called throught
 * a delegate call from the BetPayments contract.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title ERC20BetKernelProxy. */
contract ERC20BetKernelProxy is RegistrySetter, BetKernelProxyInterface {

    modifier onlyBetOwner(bytes32 _betHash) {
        require(betRegistry.getBetCreator(_betHash) == msg.sender);
        _;
    }

    /**
     * @dev Function that places a bet and returns its hash
     * @param _betHash bytes32 the hash of the bet
     * @param _option uint the option voted
     * @param _number uint the amount voted
     * @return bool the amount of tokens sent
     */
    function placeBet(
        bytes32 _betHash,
        bytes32 _playerBetHashProof,
        uint _option,
        uint _number
    )
        public
        returns(bool)
    {
        require(bytes(betRegistry.getOptionTitle(_betHash, _option)).length != 0);

        address _paymentsProxy = betRegistry.getBetPaymentsProxy(_betHash);
        address _paymentsToken = betRegistry.getBetPaymentsToken(_betHash);

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
                _number
            )
        );
        // Creating the actual bet and returning the hash
        bytes32 _playerBetHash = betRegistry.insertPlayerBet(
            _betHash,
            msg.sender,
            _option,
            _number
        );

        require(_playerBetHashProof == _playerBetHash);

        betRegistry.addTotalPrincipal(
            _betHash,
            _number
        );
        betRegistry.addToOption(
            _betHash,
            _option,
            _number
        );

        return true;

    }

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

        return true;
    }
}
