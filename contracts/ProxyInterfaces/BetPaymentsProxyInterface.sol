pragma solidity 0.4.24;


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
        uint _chosen // Will be used in the following way:
            // ERC20 --> if it has the selected amount
            // ERC721 --> if it is owner of the selected tokenId
    ) external view returns(bool);
}
