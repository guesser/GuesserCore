var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");
// Bet Payments Proxy
const ERC20PaymentProxy = artifacts.require("ERC20PaymentProxy");
const DummyToken = artifacts.require("DummyToken");
// BetTerms Proxy
const OwnerBased = artifacts.require("OwnerBased");
// BetOracle Proxy
const OwnerBasedOracle = artifacts.require("OwnerBasedOracle");

contract("Bet Kernel Exceptions Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;
    var betHash;
    var playerBetHash;
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
    const ATTACKER_1 = accounts[3];
    const WINNER_1 = accounts[4];

    before(async () => {
        betKernel = await BetKernel.new();
        betPayments = await BetPayments.new();
        betOracle = await BetOracle.new();
        betTerms = await BetTerms.new();

        betRegistry = await BetRegistry.new(
            betKernel.address,
            betPayments.address,
            betOracle.address,
            betTerms.address
        );

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
        // Creating the bet
        betHash = await betRegistry.createBet.call(
            erc20PaymentProxy.address,
            token.address,
            ownerBasedOracle.address,
            ownerBased.address,
            termsHash,
            1 // Salt
        );
        await betRegistry.createBet(
            erc20PaymentProxy.address,
            token.address,
            ownerBasedOracle.address,
            ownerBased.address,
            termsHash,
            1 // Salt
        );

        await betKernel.setBetRegistry(betRegistry.address);
        await betPayments.setBetRegistry(betRegistry.address);
        await token.approve(betPayments.address, 5, {from: BETTER_1});
    });
    
    it("should not be allowed to place a bet when user doesn't have the money", async () => {
        // When the user has the money but haven't set the approval
        try{
            await betKernel.placeBet(
                betHash,
                2,
                5,
                {from: BETTER_2}
            );
            expect(true).to.be.equal(false);
        } catch (err) {
            expect(err)
        }

        // When the user doesn't have the money
        try{
            await betKernel.placeBet(
                betHash,
                2,
                5,
                {from: ATTACKER_1}
            );
            expect(true).to.be.equal(false);
        } catch (err) {
            expect(err)
        }
    });

    it("should not be allowed to place a bet when it is not open", async () => {
        await ownerBased.changePeriod(
            termsHash,
            1
        );
        try{
            await betKernel.placeBet(
                betHash,
                2,
                5,
                {from: BETTER_1}
            );
        } catch (err) {
            expect(err);
        }
    });

    it("shouldn't allow to get the money when it isn't time yet", async () => {
        await ownerBased.changePeriod(
            termsHash,
            0
        );
        playerBetHash = await betKernel.placeBet.call(
            betHash,
            2,
            5,
            {from: BETTER_1}
        );
        await betKernel.placeBet(
            betHash,
            2,
            5,
            {from: BETTER_1}
        );
        expect(
            await betRegistry.getPlayerBetPlayer.call(betHash, playerBetHash)
        ).to.be.equal(BETTER_1)

        try {
            await betKernel.getProfits(
                betHash,
                playerBetHash,
                {from: BETTER_1}
            );
            expect(true).to.be.equal(false);
        } catch (err) {
            expect(err);
        }
    });

    it("shouldn't allow to get the money from a bet you don't own", async () => {
        await ownerBasedOracle.setOutcome(betHash, 2);
        await ownerBasedOracle.setOutcomeReady(betHash, true);
        await ownerBased.changePeriod(
            termsHash,
            2
        );
        try {
            await betKernel.getProfits(
                betHash,
                playerBetHash,
                {from: ATTACKER_1}
            );
            expect(true).to.be.equal(false);
        } catch (err) {
            expect(err);
        }
        let profits = await betKernel.getProfits.call(
                betHash,
                playerBetHash,
                {from: BETTER_1}
        );
        expect(
            profits.toNumber()
        ).to.be.equal(5);
    });

    it("shouldn't allow the user to ask twice for its money", async () => {
        await betKernel.getProfits(
            betHash,
            playerBetHash,
            {from: BETTER_1}
        );
        try {
            await betKernel.getProfits(
                betHash,
                playerBetHash,
                {from: BETTER_1}
            );
            expect(true).to.be.equal(false);
        } catch (err) {
            expect(err);
        }
    });
});
