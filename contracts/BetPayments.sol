pragma solidity ^0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./ProxyInterfaces/BetPaymentsProxyInterface.sol";


/**
 * By the moment the types supported are be:
 *  - ERC20 tokens
 *  - ERC721 tokens
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
     * @param _paymentsProxy address Address of the payments proxy
     * @param _token address Address of the better
     * @param _owner address Address of the better
     * @param _chosen uint Address of the better
     * @return bool the balance of the user
     */
    function allowance(
        address _paymentsProxy,
        address _token,
        address _owner,
        uint _chosen
    )
        public
        view
        returns(bool)
    {
        return BetPaymentsProxyInterface(_paymentsProxy).allowance(
            _token,
            _owner,
            _chosen
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
        betRegistry.isAuthorised(msg.sender);
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
     * @param _paymentsProxy address Address of the proxy
     * @param _token address Address of the token to use
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
        betRegistry.isAuthorised(msg.sender);
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

    /**
     * @dev Function that returns the balance of an address
     * @param _paymentsProxy address Address of the proxy
     * @param _token address Address fo the token to use
     * @param _address address Address of the user we want the data from
     * @return uint the amount of tokens the address holds
     */
    function balanceOf(
        address _paymentsProxy,
        address _token,
        address _address
    )
        public
        view
        returns(uint)
    {
        return BetPaymentsProxyInterface(_paymentsProxy).balanceOf(_token, _address);
    }
}
