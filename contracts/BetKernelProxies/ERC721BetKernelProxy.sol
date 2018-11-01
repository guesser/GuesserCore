pragma solidity ^0.4.24;

// Internal
import "../ProxyInterfaces/BetKernelProxyInterface.sol";
import "../RegistrySetter.sol";
import "../BetPayments.sol";
import "../BetOracle.sol";
import "../BetTerms.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";


/**
 * An ERC721 implementation for the kernel used in the Guesser Protocol
 * It has to inherate from the RegistrySetter so it can get called throught
 * a delegate call from the BetPayments contract.
 * This contract only allows 1 vs 1 bets.
 * NO MORE THAN TWO PLAYERS ARE ALLOWED TO PLAY
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title ERC721BetKernelProxy. */
contract ERC721BetKernelProxy is RegistrySetter, BetKernelProxyInterface {

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
                _number // Token Id
            )
        );

        // Creating the actual bet and returning the hash
        bytes32 _playerBetHash = betRegistry.insertPlayerBet(
            _betHash,
            msg.sender,
            _option,
            _number // Token id
        );

        require(_playerBetHashProof == _playerBetHash);

        betRegistry.addTotalPrincipal(
            _betHash,
            1
        );

        addTokenToOption(_betHash, _number);

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

        // Transfer both, his bet and the other
        transferProfits(_betHash, msg.sender);

        betRegistry.setPlayerBetReturned(_betHash, _playerBetHash, true);

        return true;
    }

    function transferProfits(
        bytes32 _betHash,
        address _receiver
    )
        private
        returns(uint)
    {
        BetPayments _betPayments = BetPayments(betRegistry.betPayments());
        require(
            _betPayments.transfer(
                betRegistry.getBetPaymentsProxy(_betHash),
                betRegistry.getBetPaymentsToken(_betHash),
                _receiver,
                betRegistry.getPrincipalInOption(_betHash, 0)
            )
        );

        require(
            _betPayments.transfer(
                betRegistry.getBetPaymentsProxy(_betHash),
                betRegistry.getBetPaymentsToken(_betHash),
                msg.sender,
                betRegistry.getPrincipalInOption(_betHash, 1)
            )
        );
    }

    function addTokenToOption(
        bytes32 _betHash,
        uint _tokenId
    )
        private
    {
        if (betRegistry.getPrincipalInOption(
            _betHash,
            0
        ) == uint(0)) {
            betRegistry.addToOption(
                _betHash,
                0,
                _tokenId
            );
        } else {
            betRegistry.addToOption(
                _betHash,
                1,
                _tokenId
            );
            // Change terms so nobody else can vote
            BetTerms _betTerms = BetTerms(betRegistry.betTerms());
            _betTerms.changePeriod(
                betRegistry.getBetTermsProxy(_betHash),
                betRegistry.getBetTermsHash(_betHash),
                1
            );
        }
    }
}
