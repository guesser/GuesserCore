pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * Collateralized is the abstract contract for the different types of elements
 * that you can use to bet in the Guesser Protocol.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
contract Collateralized is Pausable {
    using SafeMath for uint;
}
