from solcx import compile_standard
import solcx
import json
from web3 import Web3

import os
from dotenv import load_dotenv

# import Automatically the .env File in which we have our PRIVATE_KEY
load_dotenv()

# import and read the original SimpleStorage.sol File
solcx.install_solc("0.6.0")
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

# Compile Our Solidity
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)
# print(compiled_sol)


# Writing the meta data and the ABI into a Json File
with open("compled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# Get the Bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# Get the ABI
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# print(abi)

# For Connecting to Ganache
# w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:8545"))

# For Connecting to Rinkbey
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/e114871bdfa14615a5f873317ac4ca73")
)
chain_id = 4
# chain_id = 28
my_address = "0x57aA44F2AC2f4909B50F7fF220516Faa009B88B8"

# private_key = "0x077fa0c85f1364c4f9974c0427344c6842c59816dd1623b2b72aee8fba346825"
private_key = os.getenv("PRIVATE_KEY")

# Creating a Contract in Python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get the latest Transaction
nonce = w3.eth.getTransactionCount(my_address)

# Build a Transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)

# Sign a Transaction so that everybody can easily verify this transaction
sign_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("[1/4]Deploying contract...")
# Send a Transaction
tx_hash = w3.eth.send_raw_transaction(sign_txn.rawTransaction)

# creating a contract with a lil delay (wait for the transaction to be confirmed)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

print("[2/4]:Contract deployed...")
# Working with Contract, you will always need:
# Contract ABI
# Contract Address
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Call -> Simulate making the call and getting the return value (Calls don't make any state change to the Blockchain)
# Transact -> Actually make a state change


# Intitial Value of the favoriteNumber variable
print(simple_storage.functions.retrieve().call())
# # print(simple_storage.functions.store(15).call())

print("[3/4]:Updating Contract...")

# creating another transaction
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
    }
)

# Signing the above transaction
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

# Then Send the Transaction
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
# (wait for the transaction to be confirmed)
store_tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print(simple_storage.functions.retrieve().call())
print("[4/4]:Updated...")

# print(simple_storage.functions.retrieve().call())
