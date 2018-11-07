var chai = require("chai");
var expect = chai.expect;

const BetKernel = artifacts.require("BetKernel");
const BetOracle = artifacts.require("BetOracle");
const BetPayments = artifacts.require("BetPayments");
const BetTerms = artifacts.require("BetTerms");
const BetRegistry = artifacts.require("BetRegistry");
const ProxyRegistry = artifacts.require("ProxyRegistry");
// Bet Kernel Proxy
const ERC20BetKernelProxy = artifacts.require("ERC20BetKernelProxy");
// Bet Payments Proxy
const ERC20PaymentProxy = artifacts.require("ERC20PaymentProxy");
const DummyToken = artifacts.require("DummyToken");
// BetTerms Proxy
const TimeBasedProxy = artifacts.require("TimeBasedTerms");
// BetOracle Proxy
const OwnerBasedOracle = artifacts.require("OwnerBasedOracle");

const helpers = require("../helpers.js");

contract("Time Based Mutual", async accounts => {
  var betKernel;
  var betOracle;
  var betPayments;
  var betTerms;
  var betRegistry;
  var proxyRegistry;

  var betHash;
  var playerBetHash;
  // Bet Kernel Proxy
  var erc20BetKernelProxy;
  // Bet Payments
  var erc20PaymentProxy;
  var token;
  // Bet Terms
  var timeBasedProxy;
  var termsHash;
  // Bet Oracle
  var ownerBasedOracle;

  const CONTRACT_OWNER = accounts[0];

  const BETTER_1 = accounts[1];
  const BETTER_2 = accounts[2];
  const WINNER_1 = accounts[3];

  before(async () => {
    betKernel = await BetKernel.new();
    betPayments = await BetPayments.new();
    betOracle = await BetOracle.new();
    betTerms = await BetTerms.new();
    proxyRegistry = await ProxyRegistry.new();

    betRegistry = await BetRegistry.new(
      proxyRegistry.address,
      betKernel.address,
      betPayments.address,
      betOracle.address,
      betTerms.address
    );

    // Setting the bet kernel proxy
    erc20BetKernelProxy = await ERC20BetKernelProxy.new();
    // Setting bet payments
    erc20PaymentProxy = await ERC20PaymentProxy.new();
    token = await DummyToken.new("DummyToken", "DMT", 10, 10);
    await token.setBalance(BETTER_1, 5);
    await token.setBalance(BETTER_2, 5);
    // Setting the terms
    timeBasedProxy = await TimeBasedProxy.new();
    await timeBasedProxy.setBetRegistry(betRegistry.address);
    // Setting the oracle
    ownerBasedOracle = await OwnerBasedOracle.new();
    await ownerBasedOracle.setBetRegistry(betRegistry.address);
    // setting the proxies
    await proxyRegistry.setKernelProxiesAllowance(
      erc20BetKernelProxy.address,
      true
    );
    await proxyRegistry.setPaymentsProxiesAllowance(
      erc20PaymentProxy.address,
      true
    );
    await proxyRegistry.setOracleProxiesAllowance(
      ownerBasedOracle.address,
      true
    );
    await proxyRegistry.setTermsProxiesAllowance(timeBasedProxy.address, true);
  });

   it("should have the proper bet registry set", async () => {
    await betKernel.setBetRegistry(betRegistry.address);
    expect(await betKernel.betRegistry.call()).to.be.equal(betRegistry.address);
  });

  it("should allow to create a bet", async () => {
    startTime = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;
    var terms = [
      await timeBasedProxy.uintToBytes32.call(startTime + (60 * 10)),
      await timeBasedProxy.uintToBytes32.call(startTime + (60 * 20)),
      await timeBasedProxy.uintToBytes32.call(startTime + (60 * 30))
    ]

    // Creating the bet
    var betResult = await betKernel.createBet.call(
      erc20BetKernelProxy.address,
      erc20PaymentProxy.address,
      token.address,
      ownerBasedOracle.address,
      timeBasedProxy.address,
      terms,
      web3.fromAscii("Hello World"),
      1 // Salt
    );
    await betKernel.createBet(
      erc20BetKernelProxy.address,
      erc20PaymentProxy.address,
      token.address,
      ownerBasedOracle.address,
      timeBasedProxy.address,
      terms,
      web3.fromAscii("Hello World"),
      1 // Salt
    );
    betHash = betResult[0];
    termsHash = betResult[1];
  });

  it("should allow a user to place a bet", async () => {
    await betPayments.setBetRegistry(betRegistry.address);
    await token.approve(betPayments.address, 5, { from: BETTER_1 });

    await betRegistry.setOptionTitle(betHash, 0, "Option1");
    await betRegistry.setOptionTitle(betHash, 1, "Option2");
    await betRegistry.setOptionTitle(betHash, 2, "Option3");
    await betRegistry.setOptionTitle(betHash, 3, "Option4");

    playerBetHash = await betKernel.placeBet.call(betHash, 3, 5, {
      from: BETTER_1
    });

    await betKernel.placeBet(betHash, 3, 5, { from: BETTER_1 });
    let balance = await token.balanceOf(BETTER_1);
    expect(balance.toNumber()).to.be.equal(0);
    balance = await token.balanceOf(betPayments.address);
    expect(balance.toNumber()).to.be.equal(5);
  });

  it("should return the parameters of the player bet", async () => {
    const option = await betRegistry.getPlayerBetOption(betHash, playerBetHash);
    expect(option.toNumber()).to.be.equal(3);
    expect(
      await betRegistry.getPlayerBetPlayer(betHash, playerBetHash)
    ).to.be.equal(BETTER_1);
  });

  it("should allow a user to get back the profits", async () => {
    // First -> Setting the oracle
    await ownerBasedOracle.setOutcome(betHash, 3);
    await ownerBasedOracle.setOutcomeReady(betHash, true);

    // Second -> Setting the terms
    await helpers.timeTravel(60 * 11);
    await helpers.timeTravel(60 * 10);
    // Third -> Asking for the profits
    const profits = await betKernel.getProfits.call(betHash, playerBetHash, {
      from: BETTER_1
    });
    // const balance = await token.balanceOf(BETTER_1);
    expect(profits.toNumber()).to.be.equal(5);
  });
});
