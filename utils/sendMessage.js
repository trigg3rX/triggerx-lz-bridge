const { ethers } = require("ethers");
const TronWeb = require("tronweb");
const base58 = require("bs58");

const eth_abi = require("./abi/EthereumLzApp.json");

const ethContractAddress = '0x0Be2C2A71bB365ADFD3933bbcC2c30Cc1B20057a';
const trxContractAddress = 'TWKaNV2Ch5qgfHYc1yJQW9DoJLHQsBXa7x';

const tronWeb = new TronWeb({
    fullHost: process.env.SHASTA_FULL_HOST,
    privateKey: process.env.SHASTA_PRIVATE_KEY
});

const eth_provider = new ethers.JsonRpcProvider(process.env.HOLESKY_JSON_RPC_URL);

function baseToHex(base_address) {
    const decoded = base58.decode(base_address);
    const addressBytes = decoded.slice(1, -4);
    const hexAddress = '0x' + Buffer.from(addressBytes).toString('hex').padStart(40, '0');
    return hexAddress;
}

function hexToBytes32(hexAddress) {
    if (hexAddress.startsWith('0x')) {
        hexAddress = hexAddress.slice(2);
    }
    const bytes32Address = '0x' + hexAddress.padStart(64, '0');
    return bytes32Address;
}

async function setPeerHolesky() {

    const eth_contract = new ethers.Contract(ethContractAddress, eth_abi, eth_provider);
    const wallet = new ethers.Wallet(process.env.HOLESKY_PRIVATE_KEY, eth_provider);
    const contractWithSigner = eth_contract.connect(wallet);
    
    try {
        const hexAddress = baseToHex(trxContractAddress);
        const bytes32Address = hexToBytes32(hexAddress);
        const tx = await contractWithSigner.setPeer(process.env.SHASTA_EID, bytes32Address);

        const receipt = await tx.wait();
        console.log('Transaction mined: ', receipt);
    } catch (error) {
        console.error('Error setting peer:', error);
    }
}

async function setPeerShasta() {

    const trx_contract = await tronWeb.contract().at(trxContractAddress);

    try {
        const bytes32Address = hexToBytes32(ethContractAddress);

        const receipt = await trx_contract.setPeer(process.env.HOLESKY_EID, bytes32Address).send();
        console.log('Transaction sent:', receipt);
    } catch (error) {
        console.error('Error setting peer:', error);
    }
}

async function sendMessage() {
    
    const message = "Hello from Tron";

    const trx_contract = await tronWeb.contract().at(trxContractAddress);
    // console.log("Deployed contract: ", trx_contract);

    try {
        // const test = await trx_contract.addressToBytes32("TWKaNV2Ch5qgfHYc1yJQW9DoJLHQsBXa7x").call();
        // console.log("Test:", test);

        // const est_fee = await trx_contract.quote(process.env.HOLESKY_EID, message, false).call();
        // console.log("Your Estimated fee:", est_fee);

        const transaction = await trx_contract.send(process.env.HOLESKY_EID, message).send({
            shouldPollResponse: true,
            keepTxID: true
        });

        console.log("Transaction data:", transaction);
       
    } catch (error) {
        console.error("Error sending message:", error);
    }
}    


setPeerHolesky();
setPeerShasta();
sendMessage();