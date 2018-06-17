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
contract BetToken is ERC721Token, BetKernel {
}
