pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./BetPayments.sol";


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
     * @return bool if the the betting was succesfull
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
        require(
            _betPayments.transferFrom(
                _paymentsProxy,
                _paymentsToken,
                msg.sender,
                address(_betPayments),
                _amount
            )
        );
        // Creating the actual bet
        return betRegistry.placeBet(
            _betHash,
            msg.sender,
            _option,
            _amount
        );
    }
}
