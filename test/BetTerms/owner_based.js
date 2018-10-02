var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const OwnerBased = artifacts.require("OwnerBased");
const BetRegistry = artifacts.require("BetRegistry");
const ProxyRegistry = artifacts.require("ProxyRegistry");

contract("Owner Based Bet Terms Proxy Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var ownerBased;
    var betRegistry;
    var proxyRegistry;

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

        ownerBased = await OwnerBased.new();

        betRegistry = await BetRegistry.new(
            proxyRegistry.address,
            betKernel.address,
            betPayments.address,
            betOracle.address,
            ownerBased.address
        );

        await ownerBased.setBetRegistry(betRegistry.address);
    });

    it("should have the termsHash in the call and the txo", async () => {
        termsHash = await ownerBased.getTermsHash.call(
          web3.toHex('')
        );
        expect(
            await ownerBased.setTermsHash.call(
              termsHash,
              web3.toHex('')
            )
        ).to.be.equal(true);
        await ownerBased.setTermsHash(
            termsHash,
            web3.toHex('')
        );
    });

    it("should be in the participation period", async () => {
        expect(
            await ownerBased.participationPeriod(termsHash)
        ).to.be.equal(true);
    });

    it("should let the owner change to any state", async () => {
        await ownerBased.changePeriod(
            termsHash,
            1
        );
        expect(
            await ownerBased.participationPeriod(termsHash)
        ).to.be.equal(false);
        expect(
            await ownerBased.waitingPeriod(termsHash)
        ).to.be.equal(true);

        await ownerBased.changePeriod(
            termsHash,
            2
        );
        expect(
            await ownerBased.waitingPeriod(termsHash)
        ).to.be.equal(false);
        expect(
            await ownerBased.retrievingPeriod(termsHash)
        ).to.be.equal(true);

        await ownerBased.changePeriod(
            termsHash,
            3
        );
        expect(
            await ownerBased.retrievingPeriod(termsHash)
        ).to.be.equal(false);
        expect(
            await ownerBased.finishedPeriod(termsHash)
        ).to.be.equal(true);
    });
});
