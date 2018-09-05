var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
    console.log('Migration Contracts');
    deployer.deploy(Migrations);
};
