pragma solidity 0.4.24;

// Internal
import "./BetToken.sol";
// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * Stores the bets of the platform and provides a way to verify the integrity
 * of the tokens.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet BetRegistry. */
contract BetRegistry is Pausable {
    using SafeMath for uint;

    // Events
    event LogEventEntry(
        bytes32 eventEntryHash
    );

    // Storage
    struct EventEntry {
        address token;
        address oracle;
        address collateral;
        address termsContract;
        bytes32 termsHash;
    }

    // Primary registry mapping the events with their hash
    mapping(bytes32 => EventEntry) internal registry;


}
