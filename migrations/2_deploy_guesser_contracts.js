const BetKernel = artifacts.require("BetKernel");
const BetPayments = artifacts.require("BetPayments");
const BetOracle = artifacts.require("BetOracle");
const BetTerms = artifacts.require("BetTerms");
const ProxyRegistry = artifacts.require("ProxyRegistry");

module.exports = function(deployer) {
    console.log('Guesser Core Contracts');
    deployer.deploy(BetKernel);
    deployer.deploy(BetPayments);
    deployer.deploy(BetOracle);
    deployer.deploy(BetTerms);
    deployer.deploy(ProxyRegistry);
};
