pragma solidity ^0.4.12;

contract SignedContract {

    struct ContractInfo {
        string url;
        bytes32 contractHash;
    }

    uint version = 1;
    bool confirmed = false;
    address partyA;
    address partyB;
    mapping (address => bytes32) signatures;
    ContractInfo info;
    
    event SignedContractConfirmed(
        address indexed _partyA,
        address indexed _partyB,
        string _url,
        bytes32 _contractHash
    );

    modifier inBoth() {
        if (msg.sender != partyA && msg.sender != partyB) throw;
        _;
    }

    modifier notConfirmed() {
        require(confirmed == false);
        _;
    }

    function SignedContract(address to, string url, bytes32 contractHash) notConfirmed {
        if (partyB == msg.sender) throw;

        partyA = msg.sender;
        partyB = to;
        info.url = url;
        info.contractHash = contractHash;
    }
    
    function getInfoUrl() inBoth  returns(string url) {
        url = info.url;
    }
    
    function getInfoContractHash() inBoth  returns(bytes32 contractHash) {
        contractHash = info.contractHash;
    }
    
    function Signed(bytes32 sign) inBoth notConfirmed {
		address signer = msg.sender;
		signatures[signer] = sign;
		
		if (signatures[partyA] != 0 && signatures[partyB] != 0) {
		    confirmed = true;
		    SignedContractConfirmed(partyA, partyB, info.url, info.contractHash);
		}
	}
}
