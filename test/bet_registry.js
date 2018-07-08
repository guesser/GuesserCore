var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");

contract("Bet Registry Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;

    const CONTRACT_OWNER = accounts[0];

    const BETTER_1 = accounts[1];
    const BETTER_2 = accounts[2];
    const WINNER_1 = accounts[3];

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
    });

    it("should have set the proper addresses", async () => {
        const kernelAddress = await betRegistry.betKernel.call();
        const paymentsAddress = await betRegistry.betPayments.call();
        const oracleAddress = await betRegistry.betOracle.call();
        const termsAddress = await betRegistry.betTerms.call();
        expect(
            kernelAddress
        ).to.be.equal(betKernel.address);
        expect(
            paymentsAddress
        ).to.be.equal(betPayments.address);
        expect(
            oracleAddress
        ).to.be.equal(betOracle.address);
        expect(
            termsAddress
        ).to.be.equal(betTerms.address);
    });
});
