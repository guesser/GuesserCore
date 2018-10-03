var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const TimeBasedTerms = artifacts.require("TimeBasedTerms");
const BetRegistry = artifacts.require("BetRegistry");
const ProxyRegistry = artifacts.require("ProxyRegistry");

const helpers = require("../helpers.js");

contract("Times Based Bet Terms Proxy Test", async (accounts) => {
  var betKernel;
  var betOracle;
  var betPayments;
  var timeBasedTerms;
  var betRegistry;
  var proxyRegistry;
  var termsHash;

  var startTime;

  before(async () => {
    betKernel = await BetKernel.new();
    betPayments = await BetPayments.new();
    betOracle = await BetOracle.new();
    betTerms = await BetTerms.new();
    proxyRegistry = await ProxyRegistry.new();

    timeBasedTerms = await TimeBasedTerms.new();

    betRegistry = await BetRegistry.new(
      proxyRegistry.address,
      betKernel.address,
      betPayments.address,
      betOracle.address,
      timeBasedTerms.address
    );

    await timeBasedTerms.setBetRegistry(betRegistry.address);
  });

  it("should save the terms hash successfully", async () => {
    startTime = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;

    var terms = [
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 10)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 20)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 30))
    ]

    termsHash = await timeBasedTerms.getTermsHash.call(terms);
    
    expect(
      await timeBasedTerms.setTermsHash.call(terms)
    ).to.be.equal(true);

    await timeBasedTerms.setTermsHash(terms);
  });

  it("should fail saving invalid terms", async () => {
    var startTime = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;

    var invalidTerms1 = [
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 10)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 20)),
    ]

    var invalidTerms2 = [
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 10)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 20)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 20))
    ]

    var invalidTerms3 = [
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 20)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 15)),
      await timeBasedTerms.uintToBytes32.call(startTime + (60 * 30))
    ]

    try {
      await timeBasedTerms.setTermsHash.call(invalidTerms1);
      expect(false).to.be.equal(true);
    } catch(err) {
      expect(err);
    }

    try {
      await timeBasedTerms.setTermsHash.call(invalidTerms2);
      expect(false).to.be.equal(true);
    } catch(err) {
      expect(err);
    }

    try {
      await timeBasedTerms.setTermsHash.call(invalidTerms3);
      expect(false).to.be.equal(true);
    } catch(err) {
      expect(err);
    }
  });

  it("should not allow manually change state", async () => {
    expect(
      await timeBasedTerms.participationPeriod(termsHash)
    ).to.be.equal(true);
  });

  it("should change state based on time", async () => {
    expect(
      await timeBasedTerms.participationPeriod(termsHash)
    ).to.be.equal(true);

    await helpers.timeTravel(60 * 11);

    expect(
      await timeBasedTerms.participationPeriod(termsHash)
    ).to.be.equal(false);
    expect(
      await timeBasedTerms.waitingPeriod(termsHash)
    ).to.be.equal(true);

    await helpers.timeTravel(60 * 10);

    expect(
      await timeBasedTerms.waitingPeriod(termsHash)
    ).to.be.equal(false);
    expect(
      await timeBasedTerms.retrievingPeriod(termsHash)
    ).to.be.equal(true);

    await helpers.timeTravel(60 * 10);

    expect(
      await timeBasedTerms.retrievingPeriod(termsHash)
    ).to.be.equal(false);
    expect(
      await timeBasedTerms.finishedPeriod(termsHash)
    ).to.be.equal(true);
  });
});
