pragma solidity 0.4.24;

// Internal
import "./BetKernel.sol";
import "./BetPayments.sol";
import "./WETH9.sol";


/**
 * A utility contract for placing a bet by sending ETH.
 * The contract wraps the ETH into WETH and places a bet with it in the bet kernel.
 *
 * Author: Ben Kaufman -- Github: ben-kaufman
 */
/** @title EthForwarder. */
contract EthForwarder {
    BetKernel public betKernel;
    BetPayments public betPayments;
    WETH9 public wethToken;

    constructor (BetKernel _betKernel, BetPayments _betPayments, WETH9 _wethToken) public {
        betKernel = _betKernel;
        betPayments = _betPayments;
        wethToken = _wethToken;
    }

    function placeBet(
        bytes32 _betHash,
        uint _option
    )
        public
        payable
        returns(bytes32)
    {   
        require(msg.value > 0, "you must send ether to place a bet");

        wethToken.deposit.value(msg.value)();

        require(wethToken.approve(address(betPayments), msg.value), "couldn't approve weth");
                
        return betKernel.placeBet(_betHash, msg.sender, _option, msg.value);
    }
}