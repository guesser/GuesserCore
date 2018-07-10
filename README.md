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
The aim of the project is not just to have the contracts to inherit from but a way to unify the betting we all love in ethereum. We provide a protocol that we all can use easily in just a few lines of code.
The easier way to see how the platform is working is going to the tests directory and check a few of the files, like the kernel where you can see a few processes of creating a bet by an owner.

# Future
Building a betting protocol "to rule them all" is not an easy job and the number of usecases can be very different from each other. We believe creating basic layer contracts for the different growing possibilities is the way to go for now, as well as supporting any project aiming to add betting on their ethereum projects.
Also, an easy way to use the protocol by simply importing a library script is on its way. We think that through this more people will be able to develop on top of ethereum safe and easy-to-use gambling games.
There are still many things to do, so if you want to help with "a few lines" we would love to help you!
