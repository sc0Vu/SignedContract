pragma solidity ^0.4.0;

contract SignedContract {

    struct ContractInfo {
        bytes32 url;
        bytes32 contractHash;
    }

    uint public version=1;
    address public partyA;
    address public partyB;
    mapping (address => bytes32) signatures;
    ContractInfo public info;
    
    event SignedContractConfirmed(address indexed a, address indexed b);

    modifier inBoth() {
        if (msg.sender != partyA && msg.sender != partyB) throw;
        _;
    }

    function SignedContract(address to, bytes32 url, bytes32 contractHash) {
        if (partyB == msg.sender) throw;

        partyA = msg.sender;
        partyB = to;
        info.url = url;
        info.contractHash = contractHash;
    }
    
    function getInfoUrl() inBoth  returns(bytes32 url) {
        url = info.url;
    }
    
    function getInfoContractHash() inBoth  returns(bytes32 contractHash) {
        contractHash = info.contractHash;
    }
    
    function Signed(bytes32 sign) inBoth {
		address signer = msg.sender;
		signatures[signer] = sign;
		
		if (signatures[partyA] != 0 && signatures[partyB] != 0) {
		    SignedContractConfirmed(partyA, partyB);
		}
	}
}