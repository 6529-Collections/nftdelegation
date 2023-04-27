# Delegation Management

## Mainet Deployment

Network  | Deployer | Contract Address | Version
------------- | ------------- | ------------- | -------------
Ethereum Testnet  | 0x707e25f...C74bc6eE8F | [0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d](https://etherscan.io/address/0x2202cb9c00487e7e8ef21e6d8e914b32e709f43d) | 5.20.15

## Testnet Deployments

Network  | Deployer | Contract Address | Version
------------- | ------------- | ------------- | -------------
Sepolia Testnet  | 0xAcf42B8...DE9953c2a0 | [0x8f86c644f845A077999939C69Bc787662377d915](https://sepolia.etherscan.io/address/0x8f86c644f845A077999939C69Bc787662377d915) | 5.20.15

## What is it?

Simply put, the proposed contract implementation deploys a "Delegation Management" that exists purely on-chain. This means that all data and their provenance are part of the contract's state.

## Purpose

- It is often the case that wallet owners wish to assign delegation rights (in this context let's refer to assigners as "Delegators") to some other wallet address to act on their behalf.
- A Delegator can assign a delegation address for a specific use case on a specific NFT collection for a certain duration.
- We note that the action of "delegation" does not assign any ownership (including its assets) on the Delegator's wallet.

## Why is delegation useful?

- Interacting with dApps often requires signing of messages for performing certain operations. Accidentally signing a malicious transaction can authorize access to your assets.
- Delegation assignments make sense in cases where it is extremely risky to connect and sign messages from a cold wallet that is used for storing valuable fungible or non-fungible assets. Delegation addresses can be used to represent a Delegator and act on the Delegator's behalf under certain actions:

- An action could be:
  1. claiming token airdrops
  2. minting tokens from collections that require an entry to their allowlist(s)
  3. verifying/proving token ownership e.g., apps that implement some token gated policy
  4. or any other activity that relates to the above use-cases
- Overall, this contract proposal is useful for use-cases where dApps require a global, on-chain registry that maps the "delegation" relationship between wallet addresses.

## Documentation

[Write Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md)\
\
[Retrieve/Read Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Retrieve_Functions.md)

## Normal Use Cases

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

## Advanced Use Cases

#N  | Use Case
------------- | -------------
998 | Sub-delegation
999 | Consolidation

## Additional Use Cases

The 6529.io team reserved for future use the Use Cases that range from #1 to #999.

The NFTDelegation.com smart contract allows any team to create a new Use Case that can be used exclusively for their communites or applications.

To achieve this you need to call the updateUseCaseCounter() function that exists on the smart contract. By calling that function the existing numbering of the Use Cases increases by 1, ex. if you are the first one who calls the updateUseCaseCounter() function Use Case #1000 will be created and can be used during the registration of a Delegation etc.

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
  18. Function to support the Sub-Delegation process
  19. Function to check the consolidation between 2 addresses
  20. Other functions that support the smart contract's processes like retrieving of hashes etc.

Want to learn more? [Explore documentation](https://github.com/6529-Collections/nftdelegation/tree/main/Documentation)

## Why use sub-delegation if I can delegate directly with my "Vault Wallet"?
Sub-delegation allows you to reduce the number of delegation transactions you perform with your "Vault Wallet" by delegating all contract interactions, including changing delegations, to a "Delegated Wallet." This ensures your Vault remains cold (not connected) after the initial Sub-delegation.

### How it works
With your "Vault Wallet" you just need to perform one transaction registering a delegation address with sub-delegation rights. (See [how to register a delegation address](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address)). Then you can use your sub-delegated wallet to [register a delegation address on behalf of a Delegator](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address-using-an-address-with-sub-delegation-rights).

## What is Consolidation?
A consolidation is used when you want to establish an ownership connection between two addresses, such as combining the Total Days Held (TDH) of multiple wallets that you control on [seize.io](https://seize.io).

### How it works
To create a consolidation between two wallets (e.g., Wallet A and Wallet B), both wallets must register a consolidation with each other.. This means that you need to [register a delegation address](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md#how-to-register-a-delegation-address) with consolidation from Wallet A to Wallet B and vice verse, from Wallet B to Wallet A.

## Free from Dependencies

The contract is free from any dependencies.

We took the design decision to implement core functionality and include it as part of the core contract without referring to any external libraries that could (potentially) introduce additional attack vectors or vulnerabilities outside our control; since these are maintained by teams that are outside the control scope of our core implementation. Therefore, we are adopting a self-contained contract philosophy.
