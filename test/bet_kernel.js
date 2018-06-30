var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");
const OwnerBased = artifacts.require("OwnerBased");

contract("Bet Kernel Test", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betKernel;
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

        betKernel = await BetKernel.new(
            oracle.address,
            betPayment.address,
            ownerBased.address,
            termsHash
        );

        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
    });

    it("should have the proper oracle address and payments", async () => {
        const oracleAddress = await betKernel.getOracleAddress();
        expect(
          oracleAddress
        ).to.be.equal(oracle.address);
    });
});
