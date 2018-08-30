pragma solidity 0.4.24;

// Internal
import "./BetRegistry.sol";
// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * This contract allows the other core contracts to use the functions of the BetRegistry
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Registry Setter. */
contract RegistrySetter is Pausable {
    using SafeMath for uint;

    BetRegistry public betRegistry;

    /**
     * @dev Function to add the final Bet Token of the event
     * @param _betRegistry address Address of the token
     */
    function setBetRegistry (address _betRegistry)
        public
        onlyOwner
        whenNotPaused
    {
        betRegistry = BetRegistry(_betRegistry);
        pause();
    }
}
