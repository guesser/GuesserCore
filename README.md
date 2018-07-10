![banner](https://raw.githubusercontent.com/GuesserProtocol/GuesserProtocol/master/core_name.png)


# Guesser Protocol 

The Guesser protocol is a set of smart contracts built to provide developers with the necessary tools to create betting platforms on Ethereum. The aim of the protocol is to be fully upgradeable with support for any kind of purpose you have in mind. Some examples could be ERC721 collectibles betting or even lotteries.

# Installing the protocol

Guesser Protocol is a [Truffle](https://truffleframework.com/) project, and therefore we have it as primary dependency.

Install it with: 

`
$ npm install -g truffle
`

After that, clone the project and install the internal dependencies:

`
$ git clone https://github.com/GuesserProtocol/GuesserProtocol.git
$ cd GuesserProtocol && npm install
`

# Usage
Once you have the dependencies installed, you can deploy the contracts by yourself to test it out.
The first thing is to run a test chain, we have done that easier adding it to our package scripts.
- To run the chain:
`
$ npm run chain
`

- To test the project:
`
$ npm run test
`
In the future we plan to develop a Javasript library that users can import and easily use the platform without the need to touch solidity at all or do any deploys to the ethereum network, putting the barriers to usability the lower we can.

# Aim
The aim of the project is not just to have the contracts to inherit from but a way to unify the betting we all love in ethereum. Providing with this a protocol that we all can use easily in just a few lines of code.
The easier way to see how the platform is working is going to the tests directory and check a few of the files, like the kernel where you can see a few processes of creating a bet by an owner.

# Future
Providing a betting protocol "to rule them all" it is not an easy job and the huge use cases are very different from each other. Creating new basic contracts for the distinct and growing possibilities is the way to go at the moment, as well as providing help to any project aiming to add betting on their ethereum games.
Also, providing an easy way to use the protocol by "just" importing a library script is on the way. We think that with this, more people will be able to develop on top of ethereum safe and easy gambling games.
There are still many things to do, if you want to help with "a few lines" we would love to help you with that, there are still many things to do!
