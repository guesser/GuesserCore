pragma solidity ^0.4.24;


interface BetTermsProxyInterface {

    function setTermsHash(bytes32[] _terms)
        public
        returns(bool);

    function changePeriod(bytes32 _termsHash, uint _status)
        external;

    function getTermsHash(bytes32[] _terms)
        public
        view
        returns(bytes32);

    function participationPeriod(bytes32 _termsHash)
        external
        view
        returns(bool);

    function waitingPeriod(bytes32 _termsHash)
        external
        view
        returns(bool);

    function retrievingPeriod(bytes32 _termsHash)
        external
        view
        returns(bool);

    function finishedPeriod(bytes32 _termsHash)
        external
        view
        returns(bool);
}
