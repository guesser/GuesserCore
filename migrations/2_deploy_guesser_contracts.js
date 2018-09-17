const BetKernel = artifacts.require("BetKernel");
const BetPayments = artifacts.require("BetPayments");
const BetOracle = artifacts.require("BetOracle");
const BetTerms = artifacts.require("BetTerms");
const ProxyRegistry = artifacts.require("ProxyRegistry");
const RegistrySetter = artifacts.require("RegistrySetter");

module.exports = function(deployer) {
    deployer.deploy(BetKernel);
    deployer.deploy(BetPayments);
    deployer.deploy(BetOracle);
    deployer.deploy(BetTerms);
    deployer.deploy(ProxyRegistry);
    deployer.deploy(RegistrySetter);
};
