pragma solidity 0.4.24;

// Internal
import "./RegistryStorage.sol";
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
contract BetRegistry is RegistryStorage, Pausable {
    using SafeMath for uint;

    // Events
    event LogBetEntry(bytes32 _hash);

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

    modifier onlyAuthorised {
        require(
            msg.sender == betKernel ||
            msg.sender == betPayments ||
            msg.sender == betOracle ||
            msg.sender == betTerms
        );
        _;
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
        address _paymentsToken,
        address _oracleProxy,
        address _termsProxy,
        bytes32 _termsHash,
        uint _salt
    ) public returns(bytes32) {
        BetEntry memory _entry = BetEntry(
            _paymentsProxy,
            _paymentsToken,
            _oracleProxy,
            _termsProxy,
            _termsHash,
            msg.sender,
            0
        );
        bytes32 _hash = keccak256(
            abi.encodePacked(
                _paymentsProxy,
                _paymentsToken,
                _oracleProxy,
                _termsProxy,
                _termsHash,
                msg.sender,
                _salt
            )
        );
        require(betRegistry[_hash].creator == address(0));

        betRegistry[_hash] = _entry;
        emit LogBetEntry(_hash);
        return _hash;
    }

    /**
     * @dev Function adds a bet from a player to a bet
     * @param _betHash bytes32 of the bet you want to get
     * @param _sender address of the sender
     * @param _option uint the choosen option by the player
     * @param _amount uint the quantity of tokens bet
     * @return bool if the the betting was succesfull
     */
    function placeBet(
        bytes32 _betHash,
        address _sender,
        uint _option,
        uint _amount
    )
        public
        onlyAuthorised
        returns(bytes32) 
    {
        require(betRegistry[_betHash].creator != address(0));

        GameBet memory _bet = GameBet(
            _sender,
            _option,
            _amount
        );

        bytes32 _gameBetHash = keccak256(
            abi.encodePacked(
                _sender,
                _option,
                _amount,
                block.number
            )
        );

        require(betRegistry[_betHash].gameBets[_gameBetHash].player == address(0));
        betRegistry[_betHash].gameBets[_gameBetHash] = _bet;

        return _gameBetHash;
    }

    /**
     * @dev Function that returns the Bet of a given hash
     * @param _betHash of the bet you want to get
     * @return BetEntry the bet struct
     */
    function getBetEntry(bytes32 _betHash)
        public
        view
        onlyAuthorised
        returns
    (
        address,
        address,
        address,
        address,
        bytes32,
        address,
        uint
    )
    {
        require(betRegistry[_betHash].creator != address(0));
        return (
            betRegistry[_betHash].paymentsProxy,
            betRegistry[_betHash].paymentsToken,
            betRegistry[_betHash].oracleProxy,
            betRegistry[_betHash].termsProxy,
            betRegistry[_betHash].termsHash,
            betRegistry[_betHash].creator,
            betRegistry[_betHash].totalPrincipal
        );
    }

    function getBetPaymentsProxy(bytes32 _betHash) public view returns (address) {
        return betRegistry[_betHash].paymentsProxy;
    }

    function getBetPaymentsToken(bytes32 _betHash) public view returns(address) {
        return betRegistry[_betHash].paymentsToken;
    }

    function getBetCreator(bytes32 _betHash) public view returns(address) {
        return betRegistry[_betHash].creator;
    }
}
