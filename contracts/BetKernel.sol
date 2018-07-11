pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./BetPayments.sol";
import "./BetOracle.sol";
import "./BetTerms.sol";
import "./ProxyInterfaces/BetKernelProxyInterface.sol";


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

        address _kernelProxy = betRegistry.getBetKernelProxy(_betHash);
        address _paymentsProxy = betRegistry.getBetPaymentsProxy(_betHash);
        address _paymentsToken = betRegistry.getBetPaymentsToken(_betHash);

        uint _initialBalance = _betPayments.balanceOf(
            _paymentsProxy,
            _paymentsToken,
            address(_betPayments)
        );
        require(
            _kernelProxy.delegatecall(
                bytes4(
                    keccak256(
                        "getProfits(bytes32,bytes32)"
                    )
                ),
                _betHash,
                _playerBetHash
            )
        );

        uint _finalBalance = _betPayments.balanceOf(
            _paymentsProxy,
            _paymentsToken,
            address(_betPayments)
        );
        return _initialBalance - _finalBalance;
    }
}
