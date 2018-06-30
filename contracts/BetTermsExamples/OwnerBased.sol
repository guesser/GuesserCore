pragma solidity 0.4.24;

// Internal
import "../BetTerms.sol";
import "../TermsContract.sol";
// External
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * An example of the BetTerms contract for Owner based terms events.
 * The owner whill decide if betting is still allowed to and when to ask
 * to the oracle for the information
 *
 * Author: Carlos Gonzalez -- Github: carlosgj94
 */
/** @title Owner Based Terms. */
contract OwnerBased is TermsContract, Ownable {
    using SafeMath for uint;

    event LogPeriodChanged(
        bytes32 indexed _termsHash,
        uint _status
    );

    enum Status {
        ParticipationPeriod,
        RetrievingPeriod,
        FinishedPeriod
    }
    mapping(bytes32 => uint) hashStatus;
    uint betAmount = 0;

    /**
     * @dev Function that returns a terms hash for the next event
     * @return bytes32 the terms hash
     */
    function getTermsHash()
        public
        view
        returns(bytes32)
    {
        return keccak256(
            abi.encodePacked(
                msg.sender,
                betAmount
            )
        );
    }

    /**
     * @dev Function that given a terms hash creates it if it is true
     * @param _termsHash bytes32 the random number to create the terms hash
     */
    function setTermsHash(bytes32 _termsHash)
        public
        returns(bool)
    {
        bytes32 _hash = keccak256(
            abi.encodePacked(
                msg.sender,
                betAmount
            )
        );

        require(_termsHash == _hash);

        // Setting the hash to the first state of the enum
        hashStatus[_hash] = 0;
        betAmount++;
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
     * @dev Function that tells if the period for playing is over
     * @param _termsHash bytes32 of the event
     * @return bool if the period for betting is over
     */
    function retrievingPeriod(bytes32 _termsHash)
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
     * @dev Function that tells if the event is over
     * @param _termsHash bytes32 of the event
     * @return bool if the event is over
     */
    function finishedPeriod(bytes32 _termsHash)
        public
        view
        returns(bool)
    {
        if(hashStatus[_termsHash] == 2)
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
        onlyOwner
    {
        hashStatus[_termsHash] = _status;
        emit LogPeriodChanged(_termsHash, _status);
    }
}
