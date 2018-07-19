module.exports = function(deployer) {
    // Requirements
    const BetKernel = artifacts.require("BetKernel");
    const BetPayments = artifacts.require("BetPayments");
    const BetOracle = artifacts.require("BetOracle");
    const BetTerms = artifacts.require("BetTerms");

    // New Deploys
    const BetRegistry = artifacts.require("BetRegistry");

    return deployer.then(async () => {
        const kernel = await BetKernel.deployed();
        const payments = await BetPayments.deployed();
        const oracle = await BetOracle.deployed();
        const terms = await BetTerms.deployed();

        // Deploying the registry
        await deployer.deploy(
            BetRegistry,
            kernel.address,
            payments.address,
            oracle.address,
            terms.address
        );
        const registry = await BetRegistry.deployed();

        console.log("BetKernel address: ", kernel.address);
        console.log("BetPayments address: ", payments.address);
        console.log("BetOracle address: ", oracle.address);
        console.log("BetTerms address: ", terms.address);
        console.log("BetRegistry address: ", registry.address);
    });
};
