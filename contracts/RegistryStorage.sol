pragma solidity 0.4.24;


contract RegistryStorage {
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
}
