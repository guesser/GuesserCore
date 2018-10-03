pragma solidity 0.4.24;

// Internal
import "../RegistrySetter.sol";
import "../ProxyInterfaces/BetTermsProxyInterface.sol";


/**
 * An example of the BetTerms contract for time based terms events.
 * Times for each phase of the bet are predefined by the terms.
 *
 * Author: Ben Kaufman -- Github: ben-kaufman
 */
/** @title Owner Based Terms. */
contract TimeBasedTerms is RegistrySetter, BetTermsProxyInterface {

    struct BetTerms {
        uint256 participationPeriod;
        uint256 waitingPeriod;
        uint256 retrievingPeriod;
    }

    mapping(bytes32 => BetTerms) internal betsTerms;

    function changePeriod(bytes32, uint)
        external {
        revert("This terms contract doesn't support this operation");
    }

    /**
     * @dev Function that returns a terms hash for the next event
     * @return bytes32 the terms hash
     */
    function getTermsHash(bytes32[] _terms) public view returns(bytes32) {
        uint256 _participationPeriod = uint256(_terms[0]);
        uint256 _waitingPeriod = uint256(_terms[1]);
        uint256 _retrievingPeriod = uint256(_terms[2]);

        return keccak256(
            abi.encodePacked(
                _participationPeriod,
                _waitingPeriod,
                _retrievingPeriod
            )
        );
    }

    function setTermsHash(bytes32[] _terms) public returns(bool) {
        uint256 _participationPeriod = uint256(_terms[0]);
        uint256 _waitingPeriod = uint256(_terms[1]);
        uint256 _retrievingPeriod = uint256(_terms[2]);

        // solium-disable-next-line security/no-block-members
        require(_participationPeriod > now, "Participation period must be until future deadline");
        require(_waitingPeriod > _participationPeriod, "Waiting period must end after participation period");
        require(_retrievingPeriod > _waitingPeriod, "Retrieving period must end after waiting period");
        
        bytes32 hash = getTermsHash(_terms);
        betsTerms[hash] = BetTerms(_participationPeriod, _waitingPeriod, _retrievingPeriod);

        return true;
    }

    /**
     * @dev Function that tells if it is the period for playing
     * @param _termsHash bytes32 of the event
     * @return bool if it is the period for playing
     */
    function participationPeriod(bytes32 _termsHash) public view returns(bool) {
        // solium-disable-next-line security/no-block-members
        return betsTerms[_termsHash].participationPeriod > now;
    }

    /**
     * @dev Function that tells if the event is in stand by
     * @param _termsHash bytes32 of the event
     * @return bool if it is the waiting period
     */
    function waitingPeriod(bytes32 _termsHash) public view returns(bool) {
        // solium-disable-next-line security/no-block-members
        return betsTerms[_termsHash].participationPeriod < now && betsTerms[_termsHash].waitingPeriod > now;
    }

    /**
     * @dev Function that tells if the period for playing is over
     * @param _termsHash bytes32 of the event
     * @return bool if the period for betting is over
     */
    function retrievingPeriod(bytes32 _termsHash) public view returns(bool) {
        // solium-disable-next-line security/no-block-members
        return betsTerms[_termsHash].waitingPeriod < now && betsTerms[_termsHash].retrievingPeriod > now;
    }

    /**
     * @dev Function that tells if the event is over
     * @param _termsHash bytes32 of the event
     * @return bool if the event is over
     */
    function finishedPeriod(bytes32 _termsHash) public view returns(bool) {
        // solium-disable-next-line security/no-block-members
        return betsTerms[_termsHash].waitingPeriod < now;
    }

    function uintToBytes32(uint _number) public pure returns (bytes32) {
        bytes32 _b = bytes32(_number);
        
        return _b;
    }
}
