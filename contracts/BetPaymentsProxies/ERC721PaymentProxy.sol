pragma solidity ^0.4.24;

// Internal
import "../ProxyInterfaces/BetPaymentsProxyInterface.sol";
import "../RegistrySetter.sol";
// External
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";


/**
 * An ERC721 implementation for the payments used in the Guesser Protocol
 * It has to inherate from the RegistrySetter so it can get called throught
 * a delegate call from the BetPayments contract.
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title ERC721PaymentProxy. */
contract ERC721PaymentProxy is RegistrySetter, BetPaymentsProxyInterface {

    /**
     * @dev Function that tells the balance of the bet
     * @param _token address Address of the token contract where we are looking
     * @param _owner address Address of the better
     * @param _chosen uint the chosen token we want to check the allowance
     * @return uint the balance of the user
     */
    function allowance(address _token, address _owner, uint _chosen)
        public
        view
        returns(bool)
    {
        if (ERC721(_token).getApproved(_chosen) == msg.sender &&
                ERC721(_token).ownerOf(_chosen) == _owner)
            return true;
        else
            return false;
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _token address Address of the token to transfer
     * @param _from address Address of the current owner
     * @param _to address Address of the beneficiary
     * @param _tokenId uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint _tokenId
    )
        public
        returns(bool)
    {
        ERC721(_token).transferFrom(_from, _to, _tokenId);
        return true;
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _token address Address of the token to transfer
     * @param _to address Address of the beneficiary
     * @param _tokenId uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transfer(
        address _token,
        address _to,
        uint _tokenId
    )
        public
        returns(bool)
    {
        ERC721(_token).transferFrom(address(this), _to, _tokenId);
        return true;
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
        return ERC721(_token).balanceOf(_address);
    }
}
