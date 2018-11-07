var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");
const ProxyRegistry = artifacts.require("ProxyRegistry");
// Bet Kernel Proxy
const ERC721BetKernelProxy = artifacts.require("ERC721BetKernelProxy");
// Bet Payments Proxy
const ERC721PaymentProxy = artifacts.require("ERC721PaymentProxy");
const DummyToken = artifacts.require("DummyERC721Token");
// BetTerms Proxy
const OwnerBased = artifacts.require("OwnerBased");
// BetOracle Proxy
const OwnerBasedOracle = artifacts.require("OwnerBasedOracle");

contract("ERC721 Bet Kernel Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;
    var proxyRegistry;

    var betHash;
    var playerBetHash;
    var playerBetHash2;
    // Bet Kernel Proxy
    var erc721BetKernelProxy;
    // Bet Payments
    var erc721PaymentProxy;
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
        erc721BetKernelProxy = await ERC721BetKernelProxy.new();
        // Setting bet payments
        erc721PaymentProxy = await ERC721PaymentProxy.new();
        token = await DummyToken.new(
            5,
            "DummyToken",
            "DMT"
        );       
        await token.transferFrom(CONTRACT_OWNER, BETTER_1, 4);
        await token.transferFrom(CONTRACT_OWNER, BETTER_2, 1);
        // Setting the terms
        ownerBased = await OwnerBased.new();
        await ownerBased.setBetRegistry(betRegistry.address);
        termsHash = await ownerBased.getTermsHash.call(
          [web3.toHex('')]
        );
        // Setting the oracle
        ownerBasedOracle = await OwnerBasedOracle.new();
        // setting the proxies
        await proxyRegistry.setKernelProxiesAllowance(erc721BetKernelProxy.address, true);
        await proxyRegistry.setPaymentsProxiesAllowance(erc721PaymentProxy.address, true);
        await proxyRegistry.setOracleProxiesAllowance(ownerBasedOracle.address, true);
        await proxyRegistry.setTermsProxiesAllowance(ownerBased.address, true);

        // Creating the bet
        betHash = await betRegistry.createBet.call(
            erc721BetKernelProxy.address,
            erc721PaymentProxy.address,
            token.address,
            ownerBasedOracle.address,
            ownerBased.address,
            termsHash,
            web3.fromAscii("Hello World"),
            BETTER_1,
            1 // Salt
        );
        await betRegistry.createBet(
            erc721BetKernelProxy.address,
            erc721PaymentProxy.address,
            token.address,
            ownerBasedOracle.address,
            ownerBased.address,
            termsHash,
            web3.fromAscii("Hello World"),
            BETTER_1,
            1 // Salt
        );
    });

    it("should allow a user to place a bet", async () => {
        await betPayments.setBetRegistry(betRegistry.address);
        await betKernel.setBetRegistry(betRegistry.address);
        await betTerms.setBetRegistry(betRegistry.address);
        await token.approve(betPayments.address, 4, {from: BETTER_1});

        playerBetHash = await betKernel.placeBet.call(
            betHash,
            3,
            4,
            {from: BETTER_1}
        );

        await betKernel.placeBet(
            betHash,
            3,
            4,
            {from: BETTER_1}
        );
        let balance = await token.balanceOf(BETTER_1);
        expect(
            balance.toNumber()
        ).to.be.equal(0);
        balance = await token.balanceOf(betPayments.address);
        expect(
            balance.toNumber()
        ).to.be.equal(1);

        // Second bet
        await token.approve(betPayments.address, 1, {from: BETTER_2});
        playerBetHash2 = await betKernel.placeBet.call(
            betHash,
            3,
            1,
            {from: BETTER_2}
        );

        await betKernel.placeBet(
            betHash,
            3,
            1,
            {from: BETTER_2}
        );
        balance = await token.balanceOf(BETTER_2);
        expect(
            balance.toNumber()
        ).to.be.equal(0);
        balance = await token.balanceOf(betPayments.address);
        expect(
            balance.toNumber()
        ).to.be.equal(2);

        expect(
            await ownerBased.waitingPeriod(termsHash)
        ).to.be.equal(true);
    });

    it("should return the parameters of the player bet", async () => {
        let option = await betRegistry.getPlayerBetOption(betHash, playerBetHash);
        expect(
            option.toNumber()
        ).to.be.equal(3);

        expect(
            await betRegistry.getPlayerBetPlayer(betHash, playerBetHash)
        ).to.be.equal(BETTER_1)

        option = await betRegistry.getPrincipalInOption(betHash, 0);
        expect(
            option.toNumber()
        ).to.be.equal(4);
    });

    it("should allow a user to get back the profits", async () => {
        // First -> Setting the oracle
        await ownerBasedOracle.setOutcome(betHash, 3);
        await ownerBasedOracle.setOutcomeReady(betHash, true);

        // Second -> Setting the terms
        await ownerBased.changePeriod(
            termsHash,
            2
        );
        // Third -> Asking for the profits
        await betKernel.getProfits(
            betHash,
            playerBetHash,
            {from: BETTER_1}
        );
        const balance = await token.balanceOf(BETTER_1);
        expect(
            balance.toNumber()
        ).to.be.equal(2);
    });
});
