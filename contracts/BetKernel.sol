pragma solidity ^0.4.24;

// Internal
import "./Collateralizer.sol";

// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * The BetKernel is the hub for all the business logic governing
 * the betting protocol of Guesser.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
contract BetKernel is Pausable {
  using SafeMath for uint;
}
