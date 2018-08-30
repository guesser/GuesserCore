var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");
const ProxyRegistry = artifacts.require("ProxyRegistry");
// Bet Kernel Proxy
const ERC20BetKernelProxy = artifacts.require("ERC20BetKernelProxy");
// Bet Payments Proxy
const ERC20PaymentProxy = artifacts.require("ERC20PaymentProxy");
const DummyToken = artifacts.require("DummyToken");
// BetTerms Proxy
const OwnerBased = artifacts.require("OwnerBased");
// BetOracle Proxy
const OwnerBasedOracle = artifacts.require("OwnerBasedOracle");

contract("Owner Based Bet Oracle Proxy Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;
    var proxyRegistry;
    var betHash;
    // Bet Kernel Proxy
    var erc20BetKernelProxy;
    // Bet Payments
    var erc20PaymentProxy;
    var token;
    // Bet Terms
    var ownerBased;
    var termsHash;
    // Bet Oracle
    var ownerBasedOracle;


    const CONTRACT_OWNER = accounts[0];

    const BETTER_1 = accounts[1];
    const BETTER_2 = accounts[2];
    const WINNER_1 = accounts[3];

    before(async () => {
        betKernel = await BetKernel.new();
        betPayments = await BetPayments.new();
        betOracle = await BetOracle.new();
        betTerms = await BetTerms.new();
        proxyRegistry = await ProxyRegistry.new();

        betRegistry = await BetRegistry.new(
            proxyRegistry.address,
            betKernel.address,
            betPayments.address,
            betOracle.address,
            betTerms.address
        );

        // Setting the bet kernel proxy
        erc20BetKernelProxy = await ERC20BetKernelProxy.new();
        // Setting bet payments
        erc20PaymentProxy = await ERC20PaymentProxy.new();
        token = await DummyToken.new(
            "DummyToken",
            "DMT",
            10,
            10
        );       
        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
        // Setting the terms
        ownerBased = await OwnerBased.new();
        termsHash = await ownerBased.getTermsHash.call();
        // Setting the oracle
        ownerBasedOracle = await OwnerBasedOracle.new();
        // setting the proxies
        await proxyRegistry.setKernelProxiesAllowance(erc20BetKernelProxy.address, true);
        await proxyRegistry.setPaymentsProxiesAllowance(erc20PaymentProxy.address, true);
        await proxyRegistry.setOracleProxiesAllowance(ownerBasedOracle.address, true);
        await proxyRegistry.setTermsProxiesAllowance(ownerBased.address, true);

        // Creating the bet
        betHash = await betRegistry.createBet.call(
            erc20BetKernelProxy.address,
            erc20PaymentProxy.address,
            token.address,
            ownerBasedOracle.address,
            ownerBased.address,
            termsHash,
            web3.fromAscii("Hola Mundo"),
            1 // Salt
        );
    });

    it("should not have the outcome ready by default", async () => {
        expect(
            await betOracle.outcomeReady.call(
                ownerBasedOracle.address,
                betHash
            )
        ).to.be.equal(false);
    });

    it("should let the owner to change the outcome of the bet", async () => {
        await ownerBasedOracle.setOutcome(betHash, 3);
        await ownerBasedOracle.setOutcomeReady(betHash, true);
        expect(
            await ownerBasedOracle.outcomeReady.call(
                betHash
            )
        ).to.be.equal(true);

        const outcome = await ownerBasedOracle.getOutcome.call(
                betHash
        );

        expect(
            outcome.toNumber()
        ).to.be.equal(3);
    });

    it("should show the changes of the outcome in the BetOracle", async () => {
        expect(
            await betOracle.outcomeReady.call(
                ownerBasedOracle.address,
                betHash
            )
        ).to.be.equal(true);

        const outcome = await betOracle.getOutcome.call(
            ownerBasedOracle.address,
            betHash
        );

        expect(
            outcome.toNumber()
        ).to.be.equal(3);
    });
});
