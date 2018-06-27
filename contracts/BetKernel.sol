pragma solidity 0.4.24;

// Internal
import "./BetPayments.sol";
import "./Oracle.sol";
import "./BetTerms.sol";


/**
 * The BetKernel is the hub for all the business logic governing
 * the betting protocol of Guesser.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet kernel. */
contract BetKernel is BetTerms {

    Oracle oracle;
    BetPayments paymentsContract;

    constructor(
        address _oracle,
        address _paymentsContract
        ) public
    {
        // TODO: Check if both are correct implementations of the interface
        oracle = Oracle(_oracle);
        paymentsContract = BetPayments(_paymentsContract);
    }

    // Internal variables getters

    function getPaymentsContractAddress()
        public
        view
        returns(address)
    {
        return address(paymentsContract);
    }

    function getOracleContractAddress()
        public
        view
        returns(address)
    {
        return address(oracle);
    }
}
