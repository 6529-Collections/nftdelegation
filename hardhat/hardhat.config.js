require("@nomicfoundation/hardhat-toolbox")
require("hardhat-gas-reporter")

module.exports = {
  paths: {
    sources: "./smart-contracts",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.19",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  gasReporter: {
    enabled: true,
  },
}
