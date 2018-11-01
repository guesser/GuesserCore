pragma solidity ^0.4.24;


interface BetOracleProxyInterface {

    function outcomeReady(
        bytes32 _betHash
    ) external view returns(bool);

    function getOutcome(
        bytes32 _betHash
    ) external view returns(uint);
}
