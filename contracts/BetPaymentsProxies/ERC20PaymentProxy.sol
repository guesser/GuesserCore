pragma solidity ^0.4.24;

// Internal
import "../ProxyInterfaces/BetPaymentsProxyInterface.sol";
import "../RegistrySetter.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


/**
 * An ERC20 implementation for the payments used in the Guesser Protocol
 * It has to inherate from the BetRegistry so it can get called throught
 * a delegate call from the BetPayments contract.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title ERC20PaymentProxy. */
contract ERC20PaymentProxy is RegistrySetter, BetPaymentsProxyInterface {

    /**
     * @dev Function that tells the balance of the bet
     * @param _token address the address of the token to check out
     * @param _owner address Address of the better
     * @param _chosen uint the balance to check in the user approval
     * @return bool if the user has at least the selected amount of tokens
     */
    function allowance(address _token, address _owner, uint _chosen)
        public
        view
        returns(bool)
    {
        if (ERC20(_token).allowance(_owner, msg.sender) >= _chosen)
            return true;
        return false;
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _token address Address of the token to transfer
     * @param _from address Address of the current owner
     * @param _to address Address of the beneficiary
     * @param _amount uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint _amount
    )
        public
        returns(bool)
    {
        return ERC20(_token).transferFrom(_from, _to, _amount);
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _token address Address of the token to transfer
     * @param _to address Address of the beneficiary
     * @param _amount uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transfer(
        address _token,
        address _to,
        uint _amount
    )
        public
        returns(bool)
    {
        return ERC20(_token).transfer(_to, _amount);
    }

    /**
     * @dev Function that returns the balance of an address
     * @param _token address Address fo the token to use
     * @param _address address Address of the user we want the data from
     * @return uint the amount of tokens the address holds
     */
    function balanceOf(
        address _token,
        address _address
    )
        public
        view
        returns(uint)
    {
        return ERC20(_token).balanceOf(_address);
    }
}
