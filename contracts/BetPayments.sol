pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./ProxyInterfaces/BetPaymentsProxyInterface.sol";


/**
 * By the moment the types supported are be:
 *  - ERC20 tokens
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetPayments. */
contract BetPayments is RegistrySetter {

    // Events
    event LogPaymentReceived(
        address sender,
        uint amount
    );

    // Fallback function
    function () external payable {
        emit LogPaymentReceived(msg.sender, msg.value);
    }

    /**
     * @dev Function that tells the balance of the bet.
     * This function is used to check the balance an address has allowed to use
     * @param _owner address Address of the better
     * @return uint the balance of the user
     */
    function allowance(
        address _paymentsProxy,
        address _token,
        address _owner
    )
        public
        view
        returns(uint)
    {
        return BetPaymentsProxyInterface(_paymentsProxy).allowance(
            _token,
            _owner
        );
    }

    /**
     * @dev Function to send the profits the bet has to an address
     * @param _from address Address of the current owner
     * @param _to address Address of the beneficiary
     * @param _profit uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transferFrom(
        address _paymentsProxy,
        address _token,
        address _from,
        address _to,
        uint _profit
    )
        public
        whenPaused
        returns(bool)
    {    
        require(_paymentsProxy.delegatecall(
            bytes4(
                keccak256(
                    "transferFrom(address,address,address,uint256)"
                )
            ),
            _token,
            _from,
            _to,
            _profit
        ));
        return true;
    }

    /**
     * @dev Function to send the profits the bet has to an address
     * @param _to address Address of the beneficiary
     * @param _profit uint this will depend in the child token if it is
     * an ERC721 or ERC20 Token. But it's the profit the person gets
     * @return bool if the transaction was succesfull
     */
    function transfer(
        address _paymentsProxy,
        address _token,
        address _to,
        uint _profit
    )
        public
        whenPaused
        returns(bool)
    {    
        require(_paymentsProxy.delegatecall(
            bytes4(
                keccak256(
                    "transfer(address,address,uint256)"
                )
            ),
            _token,
            _to,
            _profit
        ));
        return true;
    }
}
