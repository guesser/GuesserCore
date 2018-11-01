pragma solidity ^0.4.24;


interface BetPaymentsProxyInterface {

    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint _profit
    ) external returns(bool);

    function transfer(
        address _token,
        address _to,
        uint _profit
    ) external returns(bool);

    function allowance(
        address _token,
        address _owner,
        uint _chosen
    ) external view returns(bool);

    function balanceOf(
        address _token,
        address _address
    ) external view returns(uint);
}
