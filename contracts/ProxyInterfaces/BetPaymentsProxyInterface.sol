pragma solidity 0.4.24;


interface BetPaymentsProxyInterface {

    function transferFrom(
        address _token,
        address _from, 
        address _to,
        uint _profit
    ) external returns(bool);

    function allowance(
        address _token,
        address _owner
    ) external view returns(uint);
}
