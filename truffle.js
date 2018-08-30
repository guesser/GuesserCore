var LedgerWalletProvider = require("truffle-ledger-provider");
var infura_apikey = "..."; // set your Infura API key
var ledgerOptions = {
    networkId: 4, // rinkeby testnet
    accountsOffset: 0 // we use the first address
};
/*
 * To sue the Ledger Wallet as a deploy mechanism you have to set it
 * with the following config:
 * - Contract data: Yes
 * - Browser Support: No
 */

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id,
            gas: 4712388,
            gasPrice: 1,
        },
        rinkeby: {
            provider: new LedgerWalletProvider(ledgerOptions, "https://rinkeby.infura.io/" + infura_apikey),
            network_id: 4,
            gas: 4612388 
        }
        live: {
            host: "localhost",
            port: 8547,
            network_id: "1",
            gas: 4000000,
            gasPrice: 10000000000, // 10 GWei, as per https://ethgasstation.info/
        },
    },
    migrations_directory: "migrations",
};
