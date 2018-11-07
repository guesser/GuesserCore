module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id,
            gas: 4712388,
            gasPrice: 1
        },
        live: {
            host: "localhost",
            port: 8547,
            network_id: "1",
            gas: 4000000,
            gasPrice: 10000000000 // 10 GWei, as per https://ethgasstation.info/
        }
    }
};
