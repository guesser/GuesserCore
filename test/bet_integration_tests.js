var chai = require("chai");
var expect = chai.expect;

const BetToken = artifacts.require("TestingBasicBetToken");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");
const OwnerBased = artifacts.require("OwnerBased");

contract("Basic Integration Tests", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betToken;
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
        termsHash = await ownerBased.getTermsHash.call();
        await ownerBased.setTermsHash(
            termsHash
        );
        betToken = await BetToken.new(
            oracle.address,
            betPayment.address,
            ownerBased.address,
            termsHash
        );

        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
    });

    it("should allow the token to tell the it is in", async () => {
        expect(
            await betToken.participationPeriod()
        ).to.be.equal(true);
    });

    it("should tell the correct period after the owner changes it", async () => {
        await ownerBased.changePeriod(termsHash, 1);
        expect(
            await betToken.participationPeriod()
        ).to.be.equal(false);

        expect(
            await betToken.waitingPeriod()
        ).to.be.equal(true);
    });
});
