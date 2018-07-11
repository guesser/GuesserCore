pragma solidity 0.4.24;


contract RegistryStorage {
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
}
