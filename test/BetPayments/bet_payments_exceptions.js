var chai = require("chai");
var expect = chai.expect;

const BetToken = artifacts.require("TestingBasicBetToken");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");
const OwnerBased = artifacts.require("OwnerBased");

contract("Bet ERC20 Payments Reverts Test", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betToken;
    var ownerBased;

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
        var termsHash = await ownerBased.getTermsHash.call(
            Math.floor(Math.random()*999999999999)
        );
        await ownerBased.getTermsHash(
            Math.floor(Math.random()*999999999999)
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

    it("should revert when trying to add a token from a not owner", async () => {
        try {
            await betPayment.addBetToken(
                betToken.address, 
                {from: BETTER_1}
            );
        } catch (err) {
            expect(err);
        }
    });

    it("should revert when trying to transfer from another that is not the token contract", async () => {
        await betPayment.addBetToken(betToken.address);
        await token.approve(betPayment.address, 5, {from: BETTER_1});
        try {
            await betPayment.transferFrom(
                BETTER_1, 
                WINNER_1, 
                5
            );
        } catch (err) {
            expect(err);
        }
    });
});
