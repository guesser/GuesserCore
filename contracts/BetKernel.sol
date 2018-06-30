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

    Oracle public oracle;
    BetPayments public paymentsContract;

    constructor(
        address _oracle,
        address _paymentsContract,
        address _termsContract,
        bytes32 _termsHash
    ) public BetTerms(
        _termsContract,
        _termsHash
    ) {
        oracle = Oracle(_oracle);
        paymentsContract = BetPayments(_paymentsContract);
    }

    function getOracleAddress() public view returns(address) {
        return address(oracle);
    }

    function getPaymentsContractAddress() public view returns(address) {
        return address(paymentsContract);
    }
}
