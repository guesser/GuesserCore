var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");

const ERC20PaymentProxy = artifacts.require("ERC20PaymentProxy");
const DummyToken = artifacts.require("DummyToken");

contract("Bet Registry Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;

    var erc20PaymentProxy;
    var token;

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

        erc20PaymentProxy = await ERC20PaymentProxy.new();
        token = await DummyToken.new(
            "DummyToken",
            "DMT",
            10,
            10
        );

        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
    });

    it("should revert when trying to add a token from a not owner", async () => {
        try {
            await betPayments.setBetRegistry(
                betRegistry.address,
                {from: BETTER_1}
            );
        } catch (err) {
            expect(err);
        }
    });

    it("should revert when trying to transfer from another that is not the token contract", async () => {
        await betPayments.setBetRegistry(betRegistry.address);
        await token.approve(betPayments.address, 5, {from: BETTER_1});
        try {
            await betPayments.transferFrom(
                erc20PaymentProxy.address,
                token.address,
                BETTER_1, 
                WINNER_1, 
                5
            );
        } catch (err) {
            expect(err);
        }
});
});
