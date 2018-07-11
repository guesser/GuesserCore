pragma solidity 0.4.24;

// External
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

/**
 * This is the registry where all the proxy addresses that can be used in
 * the bets as a parameters are
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Proxy Registry. */

contract ProxyRegistry is Pausable {
    mapping(address => bool) public paymentsProxiesAllowance;
    mapping(address => bool) public oracleProxiesAllowance;
    mapping(address => bool) public termsProxiesAllowance;

    function setPaymentsProxiesAllowance(
        address _paymentsProxy,
        bool _allowance
    )
        public
        onlyOwner
    {
        paymentsProxiesAllowance[_paymentsProxy] = _allowance;
    }

    function setOracleProxiesAllowance(
        address _oracleProxy,
        bool _allowance
    )
        public
        onlyOwner
    {
        oracleProxiesAllowance[_oracleProxy] = _allowance;
    }

    function setTermsProxiesAllowance(
        address _termsProxy,
        bool _allowance
    )
        public
        onlyOwner
    {
        termsProxiesAllowance[_termsProxy] = _allowance;
    }
}

