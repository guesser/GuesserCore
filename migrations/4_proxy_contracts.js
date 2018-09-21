module.exports = function(deployer) {
    // Requirements
    const BetKernel = artifacts.require("BetKernel");
    const BetPayments = artifacts.require("BetPayments");
    const BetOracle = artifacts.require("BetOracle");
    const BetTerms = artifacts.require("BetTerms");
    const BetRegistry = artifacts.require("BetRegistry");
    const ProxyRegistry = artifacts.require("ProxyRegistry");

    // New Deployments

    // Kernel Proxies
    const ERC20BetKernelProxy = artifacts.require("ERC20BetKernelProxy");
    const ERC721BetKernelProxy = artifacts.require("ERC721BetKernelProxy");
    // Oracle Proxies
    const BetOwnerBasedOracle = artifacts.require("BetOwnerBasedOracle");
    const OwnerBasedOracle = artifacts.require("OwnerBasedOracle");
    // Payments Proxies
    const ERC20PaymentProxy = artifacts.require("ERC20PaymentProxy");
    const ERC721PaymentProxy = artifacts.require("ERC721PaymentProxy");
    // Terms Proxies
    const OwnerBased = artifacts.require("OwnerBased");

    return deployer.then(async () => {
        const kernel = await BetKernel.deployed();
        const payments = await BetPayments.deployed();
        const oracle = await BetOracle.deployed();
        const terms = await BetTerms.deployed();
        const betRegistry = await BetRegistry.deployed();
        const proxyRegistry = await ProxyRegistry.deployed();

        await deployer.deploy(ERC20BetKernelProxy);
        await deployer.deploy(ERC721BetKernelProxy);
        await deployer.deploy(BetOwnerBasedOracle);
        await deployer.deploy(OwnerBasedOracle);
        await deployer.deploy(ERC20PaymentProxy);
        await deployer.deploy(ERC721PaymentProxy);
        await deployer.deploy(OwnerBased);

        const erc20KernelProxy = await ERC20BetKernelProxy.deployed();
        const erc721KernelProxy = await ERC721BetKernelProxy.deployed();
        const betOwnerOracleProxy = await BetOwnerBasedOracle.deployed();
        const ownerOracleProxy = await OwnerBasedOracle.deployed();
        const erc20PaymentProxy = await ERC20PaymentProxy.deployed();
        const erc721PaymentProxy = await ERC721PaymentProxy.deployed();
        const ownerTermsProxy = await OwnerBased.deployed();

        await proxyRegistry.setKernelProxiesAllowance(erc20KernelProxy.address, true);
        await proxyRegistry.setKernelProxiesAllowance(erc721KernelProxy.address, true);
        await proxyRegistry.setPaymentsProxiesAllowance(erc20PaymentProxy.address, true);
        await proxyRegistry.setPaymentsProxiesAllowance(erc721PaymentProxy.address, true);
        await proxyRegistry.setOracleProxiesAllowance(betOwnerOracleProxy.address, true);
        await proxyRegistry.setOracleProxiesAllowance(ownerOracleProxy.address, true);
        await proxyRegistry.setTermsProxiesAllowance(ownerTermsProxy.address, true);

        await ownerTermsProxy.setBetRegistry(betRegistry.address);
        await betOwnerOracleProxy.setBetRegistry(betRegistry.address);

        console.log("\x1b[35m%s", "BetKernel address: ", kernel.address);
        console.log("BetPayments address: ", payments.address);
        console.log("BetOracle address: ", oracle.address);
        console.log("BetTerms address: ", terms.address);
        console.log("BetRegistry address: ", betRegistry.address);
        console.log("ProxyRegistry address: ", proxyRegistry.address);

        console.log("ERC20BetKernelProxy address: ", erc20KernelProxy.address);
        console.log("ERC721BetKernelProxy address: ", erc721KernelProxy.address);
        console.log("BetOwnerBasedOracle address: ", betOwnerOracleProxy.address);
        console.log("OwnerBasedOracle address: ", ownerOracleProxy.address);
        console.log("ERC20PaymentProxy address: ", erc20PaymentProxy.address);
        console.log("ERC721PaymentProxy address: ", erc721PaymentProxy.address);
        console.log("OwnerBased terms address: ", ownerTermsProxy.address);
        console.log("\x1b[0m");
    });
};
