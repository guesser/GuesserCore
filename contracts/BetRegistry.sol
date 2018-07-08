pragma solidity 0.4.24;

// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * The registry is a Eternal Storage contract that saves all the data for the
 * bet protocol. The rest of the contracts will communicate with this contract
 * with getters and setters to modify the data. They will be the interface for
 * for the protocol.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Bet BetRegistry. */
contract BetRegistry is Pausable {
    using SafeMath for uint;

    // Events
    event LogBetEntry(
        bytes32 betEntryHash
    );

    // Allowed Contracts
    address public betKernel;
    address public betPayments;
    address public betOracle;
    address public betTerms;

    // Storage
    struct BetEntry {
        address paymentsProxy;
        address oracleProxy;
        address termsProxy;
        bytes32 termsHash;
        address creator;
    }

    // Primary registry mapping the events with their hash
    mapping(bytes32 => BetEntry) internal betRegistry;

    constructor(
        address _betKernel,
        address _betPayments,
        address _betOracle,
        address _betTerms
    ) public {
        betKernel = _betKernel;
        betPayments = _betPayments;
        betOracle = _betOracle;
        betTerms = _betTerms;
    }

    /**
     * @dev Function to create bets in the registry
     * @param _paymentsProxy address Direction of the payments proxy contract
     * @param _oracleProxy address Direction of the oracle proxy contract
     * @param _termsProxy address Address of the terms proxy contract
     * @param _termsHash bytes32 Address of the hash terms of the bet
     * @param _salt uint random number to provide a unique hash
     * @return bytes32 the that identifies the bet
     */
    function createBet(
        address _paymentsProxy,
        address _oracleProxy,
        address _termsProxy,
        bytes32 _termsHash,
        uint _salt
    ) public returns(bytes32) {
        BetEntry memory _entry = BetEntry(
            _paymentsProxy,
            _oracleProxy,
            _termsProxy,
            _termsHash,
            msg.sender
        );
        bytes32 _hash = keccak256(
            abi.encodePacked(
                _paymentsProxy,
                _oracleProxy,
                _termsProxy,
                _termsHash,
                msg.sender,
                _salt
            )
        );
        betRegistry[_hash] = _entry;
        emit LogBetEntry(_hash);
        return _hash;
    }

    /**
     * @dev Function that returns the Bet of a given hash
     * @param _hash of the bet you want to get
     * @return BetEntry the bet struct
     */
    function getBetEntry(bytes32 _hash)
    internal
    view
    returns(BetEntry) {
        return betRegistry[_hash];
    }
}
