pragma solidity 0.4.24;

// Internal
import "./RegistryStorage.sol";
import "./ProxyRegistry.sol";
// External
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
contract BetRegistry is RegistryStorage, ProxyRegistry {
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
            msg.sender == betTerms ||
            msg.sender == owner
        );
        _;
    }

    /**
      * @dev Function to change the bet kernel contract address
      * @param _betKernel address the address of the new bet kernel
      */
    function setBetKernel(address _betKernel) 
        public
        onlyOwner
    {
        betKernel = _betKernel;
    }

    /**
      * @dev Function to change the bet payments contract address
      * @param _betPayments address the address of the new bet payments
      */
    function setBetPayments(address _betPayments) 
        public
        onlyOwner
    {
        betPayments = _betPayments;
    }

    /**
      * @dev Function to change the bet oracle contract address
      * @param _betOracle address the address of the new bet oracle
      */
    function setBetOracle(address _betOracle) 
        public
        onlyOwner
    {
        betOracle = _betOracle;
    }

    /**
      * @dev Function to change the bet terms contract address
      * @param _betTerms address the address of the new bet terms
      */
    function setBetTerms(address _betTerms) 
        public
        onlyOwner
    {
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
        address _kernelProxy,
        address _paymentsProxy,
        address _paymentsToken,
        address _oracleProxy,
        address _termsProxy,
        bytes32 _termsHash,
        string _title,
        uint _salt
    ) public returns(bytes32) {
        require(addressInProxies(_kernelProxy));
        require(addressInProxies(_paymentsProxy));
        require(addressInProxies(_oracleProxy));
        require(addressInProxies(_termsProxy));

        BetEntry memory _entry = BetEntry(
            _kernelProxy,
            _paymentsProxy,
            _paymentsToken,
            _oracleProxy,
            _termsProxy,
            _termsHash,
            _title,
            block.timestamp,
            msg.sender,
            0
        );
        bytes32 _hash = keccak256(
            abi.encodePacked(
                _kernelProxy,
                _paymentsProxy,
                _paymentsToken,
                _oracleProxy,
                _termsProxy,
                _termsHash,
                _title,
                block.timestamp,
                msg.sender,
                _salt
            )
        );
        require(betRegistry[_hash].creator == address(0));

        betRegistry[_hash] = _entry;
        emit LogBetEntry(_hash);
        return _hash;
    }

    // Setters to place a bet
    // These are authorised only
    function insertPlayerBet(
        bytes32 _betHash,
        address _sender,
        uint _option,
        uint _number
    )
        public
        onlyAuthorised
        returns(bytes32)
    {
        require(betRegistry[_betHash].creator != address(0));

        PlayerBet memory _bet = PlayerBet(
            _sender,
            _option,
            _number,
            false
        );

        bytes32 _playerBetHash = getPlayerBetHash(
            _betHash,
            _sender,
            _option,
            _number
        );

        require(betRegistry[_betHash].playerBets[_playerBetHash].player == address(0));
        betRegistry[_betHash].playerBets[_playerBetHash] = _bet;

        return _playerBetHash;
    }

    /**
     * @dev Function that lets you add to the principal
     * @param _betHash bytes32 the bet
     * @param _number uint the amount to add
     * @return uint the totalPrincipal
     */
    function addTotalPrincipal(
        bytes32 _betHash,
        uint _number
    )
        public 
        onlyAuthorised
        returns(uint) 
    {
        require(betRegistry[_betHash].creator != address(0));

        betRegistry[_betHash].totalPrincipal += _number;
        return betRegistry[_betHash].totalPrincipal;
    }

    /**
     * @dev Function that lets you add to an option
     * @param _betHash bytes32 of the bet you want to get
     * @param _option uint the option you are betting on
     * @param _number uint the amount to add
     * @return uint the amount in that option
     */
    function addToOption(
        bytes32 _betHash,
        uint _option,
        uint _number
    )
        public
        onlyAuthorised
        returns(uint)
    {
        require(betRegistry[_betHash].creator != address(0));

        betRegistry[_betHash].principalInOption[_option] += _number;

        return betRegistry[_betHash].principalInOption[_option];
    }

    /**
     * @dev Function that returns the hash a bet would have
     * @param _betHash bytes32 the hash of the bet where place play will happen
     * @param _sender address the address that wants to bet
     * @param _option uint the option they want to bet on
     * @param _number uint the parameter of the bet. This depends if it is an
     * ERC20 or ERC721 token
     * @return bytes32 the hash of the bet the player is going to make
     */
    function getPlayerBetHash(
        bytes32 _betHash,
        address _sender,
        uint _option,
        uint _number
    )
        public
        view
        returns(bytes32)
    {
        return keccak256(
            abi.encodePacked(
                _betHash,
                _sender,
                _option,
                _number,
                block.number
            )
        );

    }

    function setOptionTitle (
        bytes32 _betHash,
        uint _option,
        string _title
    )
        public
        onlyAuthorised
    {
        betRegistry[_betHash].optionTitles[_option] = _title;
    }

    // Getters
    function getBetKernelProxy(bytes32 _betHash) public view returns (address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].kernelProxy;
    }

    function getBetPaymentsProxy(bytes32 _betHash) public view returns (address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].paymentsProxy;
    }

    function getBetPaymentsToken(bytes32 _betHash) public view returns(address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].paymentsToken;
    }

    function getBetOracleProxy(bytes32 _betHash) public view returns(address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].oracleProxy;
    }

    function getBetTermsProxy(bytes32 _betHash) public view returns(address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].termsProxy;
    }

    function getBetTermsHash(bytes32 _betHash) public view returns(bytes32) {
        require(betExists(_betHash));

        return betRegistry[_betHash].termsHash;
    }

    function getBetTitle(bytes32 _betHash) public view returns(string) {
        require(betExists(_betHash));

        return betRegistry[_betHash].title;
    }

    function getBetDatetime(bytes32 _betHash) public view returns(uint) {
        require(betExists(_betHash));

        return betRegistry[_betHash].datetime;
    }

    function getBetCreator(bytes32 _betHash) public view returns(address) {
        require(betExists(_betHash));

        return betRegistry[_betHash].creator;
    }

    function getTotalPrincipal(bytes32 _betHash) public view returns(uint) {
        require(betExists(_betHash));

        return betRegistry[_betHash].totalPrincipal;
    }

    function getPrincipalInOption(bytes32 _betHash, uint _option) public view returns(uint) {
        require(betExists(_betHash));

        return betRegistry[_betHash].principalInOption[_option];
    }

    function getOptionTitle (
        bytes32 _betHash,
        uint _option
    )
        public
        view
        returns(string)
    {
        return betRegistry[_betHash].optionTitles[_option];
    }

    function getPlayerBetPlayer(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        view
        returns(address)
    {
        require(playerBetExists(_betHash, _playerBetHash));

        return betRegistry[_betHash].playerBets[_playerBetHash].player;
    }

    function getPlayerBetOption(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        view
        returns(uint)
    {
        require(playerBetExists(_betHash, _playerBetHash));

        return betRegistry[_betHash].playerBets[_playerBetHash].option;
    }

    function getPlayerBetPrincipal(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        view
        returns(uint)
    {
        require(playerBetExists(_betHash, _playerBetHash));

        return betRegistry[_betHash].playerBets[_playerBetHash].principal;
    }

    function getPlayerBetReturned(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        view
        returns(bool)
    {
        require(playerBetExists(_betHash, _playerBetHash));

        return betRegistry[_betHash].playerBets[_playerBetHash].returned;
    }

    function betExists(bytes32 _betHash) public view returns(bool) {
        if (betRegistry[_betHash].creator == address(0))
            return false;
        return true;
    }

    function playerBetExists(bytes32 _betHash, bytes32 _playerBetHash) public view returns(bool) {
        require(betExists(_betHash));
        if (betRegistry[_betHash].playerBets[_playerBetHash].player == address(0))
            return false;
        return true;
    }

    function setPlayerBetReturned(
        bytes32 _betHash,
        bytes32 _playerBetHash,
        bool _returned
    )
        public 
        onlyAuthorised
        returns(bool)
    {
        require(playerBetExists(_betHash, _playerBetHash));
        betRegistry[_betHash].playerBets[_playerBetHash].returned = _returned;
        return true;
    }

    function isAuthorised(address _sender) public view {
        require(
            _sender == betKernel ||
            _sender == betPayments ||
            _sender == betOracle ||
            _sender == betTerms ||
            _sender == owner
        );
    }
}
