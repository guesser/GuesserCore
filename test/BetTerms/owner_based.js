var chai = require("chai");
var expect = chai.expect;

const BetTerms = artifacts.require("BetTerms");
const OwnerBased = artifacts.require("OwnerBased");

contract("Owner Based Bet Terms Proxy Test", async (accounts) => {
    var betTerms;
    var ownerBased;

    const CONTRACT_OWNER = accounts[0];

    const BETTER_1 = accounts[1];
    const BETTER_2 = accounts[2];
    const WINNER_1 = accounts[3];

    before(async () => {
        betTerms = await BetTerms.new();

        ownerBased = await OwnerBased.new();
    });

    it("should have the termsHash in the call and the txo", async () => {
        termsHash = await ownerBased.getTermsHash.call();
        expect(
            await ownerBased.setTermsHash.call(termsHash)
        ).to.be.equal(true);
        await ownerBased.setTermsHash(
            termsHash
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
