var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");
const OwnerBased = artifacts.require("OwnerBased");

contract("Owner Based Bet Terms Test", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betKernel;
    var ownerBased;
    var termsHash;

    const CONTRACT_OWNER = accounts[0];

    const BETTER_1 = accounts[1];
    const BETTER_2 = accounts[2];
    const WINNER_1 = accounts[3];

    before(async () => {
        token = await DummyToken.new(
            "DummyToken",
            "DMT",
            10,
            10
        );
        oracle = await Oracle.new();
        betPayment = await ERC20Payment.new(
            token.address
        );

        ownerBased = await OwnerBased.new();
    });

    it("should have the termsHash in the call and the txo", async () => {
        termsHash = await ownerBased.getTermsHash.call();
        await ownerBased.setTermsHash(
            termsHash
        );
    });

    it("should be in the participation period", async () => {
        betKernel = await BetKernel.new(
            oracle.address,
            betPayment.address,
            ownerBased.address,
            termsHash
        );

        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);

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
            await ownerBased.retrievingPeriod(termsHash)
        ).to.be.equal(true);

        await ownerBased.changePeriod(
            termsHash,
            2
        );
        expect(
            await ownerBased.retrievingPeriod(termsHash)
        ).to.be.equal(false);
        expect(
            await ownerBased.finishedPeriod(termsHash)
        ).to.be.equal(true);
    });
});
