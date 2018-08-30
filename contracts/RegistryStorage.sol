pragma solidity 0.4.24;

// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract RegistryStorage is Pausable {
    // Allowed Contracts
    address public betKernel;
    address public betPayments;
    address public betOracle;
    address public betTerms;
    address public proxyRegistry;

    // Storage
    struct BetEntry {
        address kernelProxy;
        address paymentsProxy;
        address paymentsToken;
        address oracleProxy;
        address termsProxy;
        bytes32 termsHash;
        string title;
        uint datetime;
        address creator;
        mapping(bytes32 => PlayerBet) playerBets;
        mapping(uint => uint) principalInOption;
        mapping(uint => string) optionTitles;
        uint totalPrincipal;
    }

    struct PlayerBet {
        address player;
        uint option;
        uint principal;
        bool returned;
    }

    // Primary registry mapping the events with their hash
    mapping(bytes32 => BetEntry) internal betRegistry;

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
}
