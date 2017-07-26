var SignedContract = artifacts.require("./SignedContract.sol");

contract('signedcontract', function(accounts) {
  var firstAccount = accounts[0];
  var secondAccount = accounts[1];
  var testUrl = 'https://drive.google.com/file/d/0Bzh9zQ23abiEQlQwWG1qMnZlbFU/view?usp=sharing';
  var testHash = '48c0ed78845bad3856285e10ee64f27daa4088f6';

  it("should get contract url and contract hash", function() {
    var contract;

    SignedContract.new(secondAccount, testUrl, testHash, {from: firstAccount}).then(function (instance) {
      contract = instance;
      return contract.getInfoUrl.call({from: firstAccount});
    }).then(function (url) {
      assert.equal(url, testUrl, "it didn't get test url from first account");
      return contract.getInfoContractHash.call({from: firstAccount});
    }).then(function (hash) {
      assert.equal(hash, testHash, "it didn't get test hash from first account");
      return contract.getInfoUrl.call({from: secondAccount});
    }).then(function (url) {
      assert.equal(url, testUrl, "it didn't get test url from second account");
      return contract.getInfoContractHash.call({from: secondAccount});
    }).then(function (hash) {
      assert.equal(hash, testHash, "it didn't get test hash from second account");
    });
  });

  it("should sign contract", function() {
    var contract;
    var event;

    SignedContract.new(secondAccount, testUrl, testHash, {from: firstAccount}).then(function (instance) {
      contract = instance;

      return contract.signed("Bob", {from: firstAccount});
    }).then(function () {
      return contract.signed("Alice", {from: secondAccount});
    }).then(function (tx) {
      var logs = tx.logs;

      assert.equal(logs.length, 1, "it didn't emit signed contract confirmed event");
      assert.equal(logs[0].event, "SignedContractConfirmed", "it didn't emit signed contract confirmed event");
      assert.equal(logs[0].args._partyA, firstAccount, "Party a must equal first account");
      assert.equal(logs[0].args._partyB, secondAccount, "Party b must equal second account");
      assert.equal(logs[0].args._url, testUrl, "Url must equal test url");
      assert.equal(logs[0].args._contractHash, testHash, "Contract hash bust equal test hash");
    });
  });
});
