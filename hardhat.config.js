require("@nomiclabs/hardhat-waffle");
require('hardhat-deploy');

module.exports = {
    solidity: "0.8.15",
    namedAccounts: {
        deployer: {
                default: 0, // take the first account as deployer by default
                1: 0 // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
        },
    },
};
