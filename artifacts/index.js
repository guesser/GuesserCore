/************************************
 *  Core Guesser Protocol Contracts  *
 ************************************/
var BetKernel = require('./contracts/BetKernel.js');
var BetOracle = require('./contracts/BetOracle.js');
var BetPayments = require('./contracts/BetPayments.js');
var BetRegistry = require('./contracts/BetRegistry.js');
var BetTerms = require('./contracts/BetTerms.js');
var ProxyRegistry = require('./contracts/ProxyRegistry.js');
var RegistrySetter = require('./contracts/RegistrySetter.js');
var RegistryStorage = require('./contracts/RegistryStorage.js');
var TermsContract = require('./contracts/TermsContract.js');

/************************************
 *  Bet Kernel Proxies Protocol Contracts  *
 ************************************/
var ERC20BetKernelProxy = require('./contracts/BetKernelProxies/ERC20BetKernelProxy.js');
var ERC721BetKernelProxy = require('./contracts/BetKernelProxies/ERC721BetKernelProxy.js');

/************************************
 *  Bet Oracle Proxies Protocol Contracts  *
 ************************************/
var BetOwnerBasedOracle = require('./contracts/BetOracleProxies/BetOwnerBasedOracle.js');
var OwnerBasedOracle = require('./contracts/BetOracleProxies/OwnerBasedOracle.js');

/************************************
 *  Bet Payment Proxies Protocol Contracts  *
 ************************************/
var ERC20PaymentProxy = require('./contracts/BetPaymentsProxies/ERC20PaymentProxy.js');
var ERC721PaymentProxy = require('./contracts/BetPaymentsProxies/ERC721PaymentProxy.js');

/************************************
 *  Bet Terms Proxies Protocol Contracts  *
 ************************************/
var OwnerBased = require('./contracts/BetTermsExamples/OwnerBased.js');
var TimeBasedTerms = require('./contracts/BetTermsExamples/TimeBasedTerms.js');

/************************************
 *  Examples Protocol Contracts  *
 ************************************/
var DummyERC721Token = require('./contracts/Examples/DummyERC721Token.js');
var DummyToken = require('./contracts/Examples/DummyToken.js');
var EtherToken = require('./contracts/Examples/EtherToken.js');

module.exports = { 
    BetKernel,
    BetOracle,
    BetPayments,
    BetRegistry,
    BetTerms,
    ProxyRegistry,
    RegistrySetter,
    RegistryStorage,
    TermsContract,
    ERC20BetKernelProxy,
    ERC721BetKernelProxy,
    BetOwnerBasedOracle,
    OwnerBasedOracle,
    ERC20PaymentProxy,
    ERC721PaymentProxy,
    OwnerBased,
    TimeBasedTerms,
    DummyERC721Token,
    DummyToken,
    EtherToken
}

