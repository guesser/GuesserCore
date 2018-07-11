var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");

const ERC721PaymentProxy = artifacts.require("ERC721PaymentProxy");
const DummyToken = artifacts.require("ERC721PaymentProxy");

contract("Bet Payments Test", async (accounts) => {
    var betKernel;
    var betOracle;
    var betPayments;
    var betTerms;
    var betRegistry;

    var erc721PaymentProxy;
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

        erc721PaymentProxy = await ERC721PaymentProxy.new();
        token = await DummyToken.new(
            "DummyToken",
            "DMT",
            10,
            10
        );

        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
    });

    it("should tell the correct bet registry associated with the payments", async () => {
        await betPayments.setBetRegistry(betRegistry.address);
        expect(
            await betPayments.betRegistry.call()
        ).to.be.equal(betRegistry.address);
    });

    it("should tell the exact balance the bet has in the payments token", async () => {
        await token.approve(betPayments.address, 5, {from: BETTER_1});

        const betPaymentBalance = await betPayments.allowance(
            erc20PaymentProxy.address,
            token.address,
            BETTER_1,
            5
        );

        expect(
            betPaymentBalance
        ).to.be.equal(true);
    });

    it("should transfer the correct amount of tokens from the payment contract", async () => {
        await betPayments.transferFrom(
            erc20PaymentProxy.address,
            token.address,
            BETTER_1,
            betPayments.address,
            5
        );
        let winnerBalance = await token.balanceOf(betPayments.address);
        expect(
            winnerBalance.toNumber()
        ).to.be.equal(5);
        let looserBalance = await token.balanceOf(BETTER_1);
        expect(
            looserBalance.toNumber()
        ).to.be.equal(0);

        await betPayments.transfer(
            erc20PaymentProxy.address,
            token.address,
            WINNER_1,
            5
        );
        winnerBalance = await token.balanceOf(WINNER_1);
        expect(
            winnerBalance.toNumber()
        ).to.be.equal(5);
        looserBalance = await token.balanceOf(betPayments.address);
        expect(
            looserBalance.toNumber()
        ).to.be.equal(0);
    });
});
