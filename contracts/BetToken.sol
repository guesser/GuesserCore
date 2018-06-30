pragma solidity 0.4.24;

// Internal
import "./BetKernel.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";


/**
 * This is the final token that users will receive as the output of creating a bet.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet Token. */
contract BetToken is BetKernel, ERC721Token {
    constructor (
        address _oracle,
        address _collateral,
        address _termsContract,
        bytes32 _termsHash
    )
    public
    BetKernel(
        _oracle,
        _collateral,
        _termsContract,
        _termsHash
    )
    ERC721Token(
        "GuesserEventToken",
        "GET"
    ) {}
}