pragma solidity 0.4.24;


interface BetKernelProxyInterface {

    function placeBet(
        bytes32 _betHash,
        bytes32 _playerBetHashProof,
        address _player,
        uint _option,
        uint _number
    ) external returns(bool);

    function getProfits(
        bytes32 _betHash,
        bytes32 _playerBetHash
    ) external returns(bool);
}
