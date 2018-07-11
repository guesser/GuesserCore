pragma solidity 0.4.24;


interface BetKernelProxyInterface {

    function getProfits(
        bytes32 _betHash,
        bytes32 _playerBetHash
    ) external view returns(uint);
}
