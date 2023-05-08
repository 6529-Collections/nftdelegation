const {NFTdelegation} = require('./NFTdelegationABI'); 

const Web3 = require ('web3')
const web3 = new Web3(new Web3.providers.HttpProvider("https://mainnet.infura.io/v3/<API KEY>>"))
const contract = new web3.eth.Contract(NFTdelegation, "0x2202CB9c00487e7e8EF21e6d8E914B32e709f43d")

const functionCall = process.argv[2];
const address = process.argv[3];
const collection = process.argv[4] == 'any'? '0x8888888888888888888888888888888888888888' : process.argv[3];
const usecase = process.argv[5];

var result;

async function retrieveDelegationAddresses() {
	result = await contract.methods.retrieveDelegationAddresses(address,collection,usecase).call()
	console.log(result);
}

async function retrieveDelegationAddressesInfo() {
	result = await contract.methods.retrieveDelegationAddressesTokensIDsandExpiredDates(address,collection,usecase).call()
	console.log(result);
}

async function retrieveDelegators() {
	result = await contract.methods.retrieveDelegators(address,collection,usecase).call()
	console.log(result);
}

async function retrieveDelegatorsInfo() {
	result = await contract.methods.retrieveDelegatorsTokensIDsandExpiredDates(address,collection,usecase).call()
	console.log(result);
}

switch (functionCall) {
	case ('retrieveDelegationAddresses'): 
		return retrieveDelegationAddresses()
	case ('retrieveDelegationAddressesInfo'): 
		return retrieveDelegationAddressesInfo()
	case ('retrieveDelegators'): 
		return retrieveDelegators()
	case ('retrieveDelegatorsInfo'): 
		return retrieveDelegatorsInfo()
	default:
		console.log('Unknown')
}
