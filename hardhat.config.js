require("@nomicfoundation/hardhat-toolbox")
require("hardhat-gas-reporter")

module.exports = {
  gasReporter: {
    enabled: true,
  },
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
};
