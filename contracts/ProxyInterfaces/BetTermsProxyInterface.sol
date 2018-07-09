pragma solidity 0.4.24;


interface BetTermsProxyInterface {

    function setTermsHash(bytes32 _termsHash)
        external 
        returns(bool);

    function getTermsHash()
        external
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
