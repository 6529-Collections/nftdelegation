# NFTDelegation.com

## Mainnet Deployments

Network  | Deployer | Contract Address 
------------- | ------------- | ------------- 
Ethereum  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://etherscan.io/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d)
Polygon  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://polygonscan.com/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d)
Binance SC  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://bscscan.com/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d)
Avalanche  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://snowtrace.io/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d)
Klaytn  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://scope.klaytn.com/account/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d?tabId=internalTx)
Arbitrum  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://arbiscan.io/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d)

## Testnet Deployments

Network  | Deployer | Contract Address 
------------- | ------------- | ------------- 
Sepolia  | 0xAcf42B8...DE9953c2a0 | [0x8f86c644f845A077999939C69Bc787662377d915](https://sepolia.etherscan.io/address/0x8f86c644f845A077999939C69Bc787662377d915)

## What is it?

Simply put, the contract deploys a "Delegation Management Registry" that exists purely on-chain. This means that all data and their provenance are part of the contract's state.

## Purpose

- It is often the case that wallet owners wish to assign delegation rights (in this context, let's refer to assigners as "Delegators") to some other wallet address to act on their behalf.
- A Delegator can assign a delegation address for a specific use case on a specific NFT collection for a certain duration.
- The action of "delegation" does not assign any ownership over—nor control of assets in—the Delegator's wallet.

## Why is delegation useful?

- Interacting with dApps often requires signing of messages for performing certain operations. Accidentally signing a malicious transaction can authorize access to your assets.
- Delegation assignments make sense in cases where it is risky to connect and sign messages from a cold wallet that is used for storing valuable fungible or non-fungible assets. Delegation addresses can be used to represent a Delegator and act on the Delegator's behalf under certain actions:

- An action could be:
  1. claiming token airdrops
  2. minting tokens from collections that require an entry to their allowlist(s)
  3. verifying/proving token ownership e.g., apps that implement some token gated policy
  4. or any other activity that relates to the above use-cases
- Overall, this contract proposal is useful for use-cases where dApps require a global, on-chain registry that maps the "delegation" relationship between wallet addresses.

## Use Cases

### Active (Canonical) Use Cases

#N  | Use Case
------------- | -------------
1  | All
2  | Minting / Allowlist
3 | Airdrops
4 | Voting / Governance
5 | Avatar Display
6 | Social Media
7 | Physical Events Access
8 | Virtual Events Access
9 | Club Access
10 | Metaverse Access
11 | Metaverse Land
12 | Gameplay
13 | IP Licensing
14 | NFT rentals
15 | View Access
16 | Manage Access
17 | Mint To Address
18 | Team
19 | Artists
20 to 949 | Reserved by NFTDelegation.com for future active (canonical) use cases

### Special Use Cases

#N  | Use Case
------------- | -------------
950 to 997 | Reserved for Future Special Use Cases
998 | Delegation Management (Sub-delegation)
999 | Consolidation

Note: Special Use Cases are not captured by Use Case #1 ("All").

### Application Specific Use Cases

#N  | Use Case
------------- | -------------
1000+ | Application-specific use cases

### Use Case Descriptions

### Active (Canonical) Use Cases

- Use cases #1 to #19 are active canonical (official) use cases.

- #20 to #949 are reserved for additional canonical use cases, to be added from time to time by NFTDelegation.com.

### Special Use Cases

- #950 to #997 are reserved for future Special use cases.

- #998 is for Delegation Management (Sub-delegation) (giving the right to another address to add or remove delegations on the initial address's behalf).

- #999 is for Consolidation (linking addresses together).

### Application Specific Use Cases

- #1,000+ are available to any team who wants to create an application-specific use case.

- Any team can call the updateUseCaseCounter() function to increment/create another use case for their own use.


## Features

Current implementation enables the following functionality:

  1. Delegator assigns a delegation address on a specific use case on a specific NFT collection for a certain duration. The Delegator can assign all tokens or a specific token to the delegation address.
  2. Delegator revokes delegation rights from a delagation address on a specific NFT collection given a specific use case
  3. Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
  4. Batch registrations of delegation addresses
  5. Batch revocations of delegation addresses
  6. Functions to change the status of a Global/Collection/Collection & UseCase Lock
  7. Function that returns an array of all delegations (active AND inactive) assigned by a delegator on a specific use case on a specific NFT collection
  8. Function that returns an array of all delegators (active AND inactive) given a delegation Address for a specific use case on a specific NFT collection
  9. Function that returns an array of all active delegations on a certain date for a specific use case on a specific NFT collection
  10. Function that returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection
  11. Retrieve functions to get the status (true/false) of a delegation
  12. Retrieve function to get the status (true/false) of a delegation given a token id
  13. Retrieve function to check if the delegation address performing any actions is the most recently delegated one
  14. Retrieve function to check the status (true/false) of an active delegator on a given date
  15. Retrieve functions to get the tokens ids as well as the expiry dates of a delegation given a delegator/delegation address
  16. Retrieve function to get the most recent delegation address delegated on a specific usecase
  17. Retrieve function to get the most recent delegator given a delegation Address
  18. Function to support the registration of Delegation Managers
  19. Function to check the consolidation between 2 addresses
  20. Other functions that support the smart contract's processes like retrieving of hashes etc.

Want to learn more? [Explore documentation](https://github.com/6529-Collections/nftdelegation/tree/main/Documentation)

## Documentation

[Write Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md)\
\
[Retrieve/Read Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Retrieve_Functions.md)

## Why use Delegation Management (Sub-delegation) if I can delegate directly with my "Vault Wallet"?

Delegation Management (sub-delegation) allows you to reduce the number of delegation transactions you perform with your "Vault Wallet" by delegating all contract interactions, including changing delegations, to a "Delegated Wallet." This ensures your Vault remains cold (not connected) after the initial Sub-delegation.

### How it works

With your "Vault Wallet" you just need to perform one transaction registering a delegation address with Delegation Management (sub-delegation) rights. (See [how to register a delegation address](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address)). Then you can use your sub-delegated wallet to [register a delegation address on behalf of a Delegator](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address-using-an-address-with-sub-delegation-rights).

## What is Consolidation?

A consolidation is used when you want to establish an ownership connection between two addresses, such as combining the Total Days Held (TDH) of multiple wallets that you control on [seize.io](https://seize.io).

### How it works

To create a consolidation between two wallets (e.g., Wallet A and Wallet B), both wallets must register a consolidation with each other. This means that you need to [register a delegation address](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address) with consolidation from Wallet A to Wallet B and vice verse, in a second transaction: from Wallet B to Wallet A.

## Free from Dependencies

The contract is free from any dependencies.

We made the design decision to implement core functionality and include it as part of the core contract without referring to any external libraries that could (potentially) introduce additional attack vectors or vulnerabilities outside our control; since these are maintained by teams that are outside the control scope of our core implementation. Therefore, we are adopting a self-contained contract philosophy.

## Tests

Sample hardhat tests are provided.

1. Download the github repo
2. Open command prompt and navigate to the hardhat folder
3. Install hardhat using `npm i`
4. Compile smart contracts using `npx hardhat compile`
  - If you get `Error HH502` then please upgrade to the laetst hardhat - `npm up hardhat`
5. Run the tests that exist within the test folder using `npx hardhat test`
