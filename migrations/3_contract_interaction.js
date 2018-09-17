module.exports = function(deployer) {
    // Requirements
    const BetKernel = artifacts.require("BetKernel");
    const BetPayments = artifacts.require("BetPayments");
    const BetOracle = artifacts.require("BetOracle");
    const BetTerms = artifacts.require("BetTerms");
    const ProxyRegistry = artifacts.require("ProxyRegistry");
    const RegistrySetter = artifacts.require("RegistrySetter");

    // New Deployments
    const BetRegistry = artifacts.require("BetRegistry");

    return deployer.then(async () => {
        const kernel = await BetKernel.deployed();
        const payments = await BetPayments.deployed();
        const oracle = await BetOracle.deployed();
        const terms = await BetTerms.deployed();
        const proxyRegistry = await ProxyRegistry.deployed();
        const registrySetter = await RegistrySetter.deployed();

        // Deploying the registry
        await deployer.deploy(
            BetRegistry,
            proxyRegistry.address,
            kernel.address,
            payments.address,
            oracle.address,
            terms.address
        );
        const registry = await BetRegistry.deployed();

        // Permissions
        await kernel.setBetRegistry(registry.address);
        await payments.setBetRegistry(registry.address);
        await oracle.setBetRegistry(registry.address);
        await terms.setBetRegistry(registry.address);
        await registrySetter.setBetRegistry(registry.address);
    });
};
