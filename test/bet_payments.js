var chai = require("chai");
var expect = chai.expect;

const BetToken = artifacts.require("TestingBasicBetToken");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");

contract("Bet ERC20 Payments Test", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betToken;

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

        betToken = await BetToken.new(
            oracle.address,
            betPayment.address
        );


        await token.setBalance(BETTER_1, 5);
        await token.setBalance(BETTER_2, 5);
    });

    it("should tell the exact address of the Bet Token the payments contract is related to", async () => {
        await betPayment.addBetToken(betToken.address);
        const betTokenAddress = await betPayment.getBetToken();
        expect(
            betTokenAddress
        ).to.be.equal(betToken.address);
    });

    it("should tell the exact balance the bet has in the payments token", async () => {
        await token.approve(betPayment.address, 5, {from: BETTER_1});
        const betPaymentBalance = await betPayment.allowance(BETTER_1);
        expect(
            betPaymentBalance.toNumber()
        ).to.be.equal(5);
    });

    it("should transfer the correct amount of tokens from the payment token", async () => {
        // Asking the skull to transfer will ask to transfer the payment
        await betToken.transferFrom(BETTER_1, WINNER_1, 5);
        const winnerBalance = await token.balanceOf(WINNER_1);
        expect(
            winnerBalance.toNumber()
        ).to.be.equal(5);
    });
});
