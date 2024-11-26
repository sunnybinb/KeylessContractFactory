require("@nomicfoundation/hardhat-toolbox");
const { vars } = require("hardhat/config");


const PRIVATE_KEY = vars.get("PRIVATE_KEY");

module.exports = {
  solidity: "0.8.27",
  networks: {
    sepolia: {
      url: "https://rpc.sepolia.org",
      accounts: [PRIVATE_KEY],
    },
    arb_sepolia: {
      url: "https://arbitrum-sepolia.gateway.tenderly.co",
      accounts: [PRIVATE_KEY],
    },

  },
  etherscan: {
    apiKey: {
      sepolia: 'UFDT2P2RSDHXGX1TUG1RJXAHPQS26GZ6I6'
    }
  }
};

