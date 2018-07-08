pragma solidity 0.4.24;

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
     * @param _owner address Address of the better
     * @return uint the balance of the user
     */
    function allowance(address _token, address _owner)
        public
        view
        returns(uint)
    {
        return ERC20(_token).allowance(_owner, msg.sender);
    }

    /**
     * @dev Function to send the profits the bet has to a winner
     * @param _from address Address of the current owner
     * @param _to address Address of the beneficiary
     * @param _profit uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint _profit
    )
        public
        returns(bool)
    {
        ERC20(_token).transferFrom(_from, _to, _profit);
        return true;
    }
}
