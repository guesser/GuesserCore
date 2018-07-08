pragma solidity 0.4.24;


// Minimal interface to implement in the TermsContractProxies
// to interact with the rest of the protocol properly
interface TermsContract {

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
