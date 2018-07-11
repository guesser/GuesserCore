var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");

const ERC721PaymentProxy = artifacts.require("ERC721PaymentProxy");
const DummyToken = artifacts.require("DummyERC721Token");

contract("ERC721 Bet Payments Test", async (accounts) => {
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
            5,
            "DummyToken",
            "DMT"
        );

        await betPayments.setBetRegistry(betRegistry.address);

        await token.transferFrom(CONTRACT_OWNER, BETTER_1, 0);
        await token.transferFrom(CONTRACT_OWNER, BETTER_2, 1);
    });

    it("should tell the exact balance the bet has in the payments token", async () => {
        await token.approve(betPayments.address, 0, {from: BETTER_1});

        let allowed = await betPayments.allowance(
            erc721PaymentProxy.address,
            token.address,
            BETTER_1,
            0
        );

        expect(
            allowed
        ).to.be.equal(true);
    });

    it("should transfer the correct amount of tokens from the payment contract", async () => {
        await betPayments.transferFrom(
            erc721PaymentProxy.address,
            token.address,
            BETTER_1,
            betPayments.address,
            0
        );
        let winnerBalance = await token.balanceOf(betPayments.address);
        expect(
            winnerBalance.toNumber()
        ).to.be.equal(1);

        let looserBalance = await token.balanceOf(BETTER_1);
        expect(
            looserBalance.toNumber()
        ).to.be.equal(0);
    });
});
