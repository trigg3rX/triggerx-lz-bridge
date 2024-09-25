const TronLzApp = artifacts.require("TronLzApp");
require('dotenv').config();

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
    // Load the Layer Zero endpoint address from the environment variable
    const lzEndpointAddress = process.env.SHASTA_ENDPOINT_V2;

    if (!lzEndpointAddress) {
      throw new Error("SHASTA_ENDPOINT_V2 not set in .env file");
    }

    // Deploy the TronLzApp contract
    await deployer.deploy(TronLzApp, lzEndpointAddress);
    const tronLzApp = await TronLzApp.deployed();

    console.log("TronLzApp deployed at:", tronLzApp.address);

    // Additional post-deployment steps can be added here
    // For example, setting trusted remote, initializing state, etc.
  });
};

/*


*/