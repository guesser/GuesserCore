pragma solidity 0.4.24;

// Internal
import "../RegistrySetter.sol";
import "../ProxyInterfaces/BetTermsProxyInterface.sol";


/**
 * An example of the BetTerms contract for Owner based terms events.
 * The owner whill decide if betting is still allowed to and when to ask
 * to the oracle for the information
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Owner Based Terms. */
contract OwnerBased is RegistrySetter, BetTermsProxyInterface {
    using SafeMath for uint;

    event LogPeriodChanged(
        bytes32 indexed _termsHash,
        uint _status
    );

    event TermsAdded(
        address indexed _sender,
        bytes32 indexed _termsHash
    );

    enum Status {
        ParticipationPeriod,
        RetrievingPeriod,
        FinishedPeriod
    }

    mapping(bytes32 => uint) internal hashStatus;
    uint public betsNumber = 0;

    /**
     * @dev Function that returns a terms hash for the next event
     * @param _terms bytes in the Owner based this parameter is not really
     * needed. But it needs to fulfill the interface.
     * @return bytes32 the terms hash
     */
    function getTermsHash(bytes32[] _terms)
        public
        view
        returns(bytes32)
    {
        return keccak256(
            abi.encodePacked(
                msg.sender,
                betsNumber,
                _terms
            )
        );
    }

    /**
     * @dev Function that given a terms hash creates it if it is true
     * @param _terms bytes32 the data being used to control the terms of the bet
     */
    function setTermsHash(bytes32[] _terms)
        public
        returns(bool)
    {
        bytes32 _hash = keccak256(
            abi.encodePacked(
                msg.sender,
                betsNumber,
                _terms
            )
        );

        emit TermsAdded(msg.sender, _hash);

        // Setting the hash to the first state of the enum
        hashStatus[_hash] = 0;
        betsNumber++;

        return true;
    }

    /**
     * @dev Function that tells if it is the period for playing
     * @param _termsHash bytes32 of the event
     * @return bool if it is the period for playing
     */
    function participationPeriod(bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        if (hashStatus[_termsHash] == 0)
            return true;
        else
            return false;
    }

    /**
     * @dev Function that tells if the event is in stand by
     * @param _termsHash bytes32 of the event
     * @return bool if it is the waiting period
     */
    function waitingPeriod(bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        if (hashStatus[_termsHash] == 1)
            return true;
        else
            return false;
    }

    /**
     * @dev Function that tells if the period for playing is over
     * @param _termsHash bytes32 of the event
     * @return bool if the period for betting is over
     */
    function retrievingPeriod(bytes32 _termsHash)
        public 
        view
        returns(bool)
    {
        if (hashStatus[_termsHash] == 2)
            return true;
        else
            return false;
    }

    /**
     * @dev Function that tells if the event is over
     * @param _termsHash bytes32 of the event
     * @return bool if the event is over
     */
    function finishedPeriod(bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        if (hashStatus[_termsHash] == 3)
            return true;
        else
            return false;
    }

    /**
     * @dev Function that allows the owner to change the period of the status
     * @param _termsHash bytes32 of the event
     * @param _status uint the status to set
     */
    function changePeriod(
        bytes32 _termsHash,
        uint _status
    )
        public
    {
        betRegistry.isAuthorised(msg.sender);

        hashStatus[_termsHash] = _status;
        emit LogPeriodChanged(_termsHash, _status);
    }
}
