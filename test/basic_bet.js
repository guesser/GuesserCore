const BetKernel = artifacts.require("BetKernel");
const Oracle = artifacts.require("Oracle");
const ERC20Payment = artifacts.require("ERC20Payment");
const DummyToken = artifacts.require("DummyToken");

contract("Basic Bet Test", async (accounts) => {
    var token;
    var oracle;
    var betPayment;
    var betKernel;
    
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

        betKernel = await BetKernel.new(
            oracle.address,
            betPayment.address
        );
    });

    it("BetKernel should have the proper oracle address and payments", async () => {
        const oracleAddress = await betKernel.getOracleContractAddress();
        assert.equal(oracleAddress, oracle.address);
    });
});
