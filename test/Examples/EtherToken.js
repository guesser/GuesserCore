var chai = require("chai");
var expect = chai.expect;

const EtherToken = artifacts.require("EtherToken");

contract("Ether Token tests", async (accounts) => {
    // Bet Oracle
    var etherToken;

    const CONTRACT_OWNER = accounts[0];

    const user1 = accounts[1];

    before(async () => {
        etherToken = await EtherToken.new();
    });

    it("should allow to buy tokens", async () => {
        await etherToken.buy({value: 10});
        let balance = await etherToken.balanceOf(CONTRACT_OWNER);
        expect(
            balance.toNumber()
        ).to.be.equal(10);
    });

    it("should allow to sell tokens", async () => {
        await etherToken.sell(10);
        let balance = await etherToken.balanceOf(CONTRACT_OWNER);
        expect(
            balance.toNumber()
        ).to.be.equal(0);
    });

});
