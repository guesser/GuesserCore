pragma solidity 0.4.24;

// Internal
import "./RegistrySetter.sol";
import "./BetPayments.sol";
import "./BetOracle.sol";
import "./BetTerms.sol";
import "./ProxyInterfaces/BetKernelProxyInterface.sol";
import "./ProxyInterfaces/BetTermsProxyInterface.sol";


/**
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title BetKernel. */
contract BetKernel is RegistrySetter {

    /**
     * @dev Function creates a bet with the selected parameters
     * @param _kernelProxy address Direction of the kernel proxy contract
     * @param _paymentsProxy address Direction of the payments proxy contract
     * @param _oracleProxy address Direction of the oracle proxy contract
     * @param _termsProxy address Address of the terms proxy contract
     * @param _terms bytes32[] The terms of the bet
     * @param _salt uint random number to provide a unique hash
     * @return bytes32 the that identifies the bet
     * @return bytes32 the terms of the created bet
     */
    function createBet(
        address _kernelProxy,
        address _paymentsProxy,
        address _paymentsToken,
        address _oracleProxy,
        address _termsProxy,
        bytes32[] _terms,
        string _title,
        uint _salt
    )
        public
        returns(bytes32, bytes32)
    {
        BetTermsProxyInterface _termsProxyContract = BetTermsProxyInterface(_termsProxy);
        bytes32 _termsHash = _termsProxyContract.getTermsHash(_terms);
        _termsProxyContract.setTermsHash(_terms);

        bytes32 _betHash = betRegistry.createBet(
            _kernelProxy,
            _paymentsProxy,
            _paymentsToken,
            _oracleProxy,
            _termsProxy,
            _termsHash,
            _title,
            _salt
        );

        return (_betHash, _termsHash);
    }

    /**
     * @dev Function adds a bet from a player to a bet
     * @param _betHash bytes32 of the bet you want to get
     * @param _option uint the choosen option by the player
     * @param _number uint the quantity of tokens bet
     * @return bool if the betting was succesfull
     */
    function placeBet(
        bytes32 _betHash,
        uint _option,
        uint _number
    )
        public
        whenPaused
        returns(bytes32)
    {
        bytes32 _playerBetHash = betRegistry.getPlayerBetHash(
            _betHash,
            msg.sender,
            _option,
            _number
        );

        address _kernelProxy = betRegistry.getBetKernelProxy(_betHash);
        require(
            _kernelProxy.delegatecall(
                bytes4(
                    keccak256(
                        "placeBet(bytes32,bytes32,uint256,uint256)"
                    )
                ),
                _betHash,
                _playerBetHash,
                _option,
                _number
            )
        );

        return _playerBetHash;
    }

    /**
     * @dev Function that ask for the profits of a user
     * @param _betHash bytes32 the hash of the bet
     * @param _playerBetHash bytes32 the hash of the game bet the player played
     * @return bool if returning profits was succesfull
     */
    function getProfits(
        bytes32 _betHash,
        bytes32 _playerBetHash
    )
        public
        returns(uint)
    {
        BetPayments _betPayments = BetPayments(betRegistry.betPayments());

        address _kernelProxy = betRegistry.getBetKernelProxy(_betHash);
        address _paymentsProxy = betRegistry.getBetPaymentsProxy(_betHash);
        address _paymentsToken = betRegistry.getBetPaymentsToken(_betHash);

        uint _initialBalance = _betPayments.balanceOf(
            _paymentsProxy,
            _paymentsToken,
            address(_betPayments)
        );
        require(
            _kernelProxy.delegatecall(
                bytes4(
                    keccak256(
                        "getProfits(bytes32,bytes32)"
                    )
                ),
                _betHash,
                _playerBetHash
            )
        );

        uint _finalBalance = _betPayments.balanceOf(
            _paymentsProxy,
            _paymentsToken,
            address(_betPayments)
        );
        return _initialBalance - _finalBalance;
    }
}
