var SignedContract = artifacts.require("./SignedContract.sol");

module.exports = function(deployer) {
  deployer.deploy(SignedContract);
};
