# Delegation Management

## Deployment

Network  | Contract Address
------------- | -------------
Goerli Testnet  | [0x6a89AFF3B4ea4CF323C32740289C8a1d703aBeC8](https://goerli.etherscan.io/address/0x6a89aff3b4ea4cf323c32740289c8a1d703abec8)

- Deployer Address: 0xAcf42B85eCb77d9332584119FD78a3DE9953c2a0
- Contract created on Goerli during TxHash# [0x2e25c4122cd6209c3cf0a4be36abd0086d350854a2b9e3bc42122f26c0ddcac3](https://goerli.etherscan.io/tx/0x2e25c4122cd6209c3cf0a4be36abd0086d350854a2b9e3bc42122f26c0ddcac3)
- Deployed version: 5.20.10

## What is it?

Simply put, the proposed contract implementation deploys a "Delegation Management" that exists purely on-chain. This means that all data and their provenance are part of the contract's state.

## Purpose

- It is often the case that wallet owners wish to assign delegation rights (in this context let's refer to assigners as "Delegators") to some other wallet address to act on their behalf.
- A Delegator can assign a delegation address for a specific use case on a specific NFT collection for a certain duration.
- We note that the action of "delegation" does not assign any ownership (including its assets) on the Delegator's wallet.

## Use Cases

Use-Case  | Action
------------- | -------------
1  | All (1-15)
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
16 | Sub-delegation
99 | Consolidation

## Documentation

[Write Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Write_Functions.md)\
\
[Retrieve/Read Functions](https://github.com/6529-Collections/nftdelegation/blob/main/Documentation/Retrieve_Functions.md)

## Why is delegation useful?

- Interacting with dApps often requires signing of messages for performing certain operations. Accidentally signing a malicious transaction can authorize access to your assets.
- Delegation assignments make sense in cases where it is extremely risky to connect and sign messages from a cold wallet that is used for storing valuable fungible or non-fungible assets. Delegation addresses can be used to represent a Delegator and act on the Delegator's behalf under certain actions:

- An action could be:
  1. claiming token airdrops
  2. minting tokens from collections that require an entry to their allowlist(s)
  3. verifying/proving token ownership e.g., apps that implement some token gated policy
  4. or any other activity that relates to the above use-cases
- Overall, this contract proposal is useful for use-cases where dApps require a global, on-chain registry that maps the "delegation" relationship between wallet addresses.

## Features

- Current implementation enables the following functionality:

  1. Delegator assigns a delegation address on a specific use case on a specific NFT collection for a certain duration. The Delegator can assign all tokens or a specific   token to the delegation address.
  2. Delegator revokes delegation rights from a delagation address on a specific NFT collection given a specific use case
  3. Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
  4. Batch registrations of delegation addresses
  5. Revoke all delegation rights assigned by a Delegator
  6. Functions to change the status of a Global/Collection/Collection&UseCase Lock
  7. Function that returns an array of all delegations (active AND inactive) assigned by a delegator on a specific use case on a specific NFT collection
  8. Function that returns an array of all delegators (active AND inactive) given a delegation Address for a specific use case on a specific NFT collection
  9. Function that returns an array of all active delegations on a certain date for a specific use case on a specific NFT collection
  10. Function that returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection
  11. Retrieve functions to get the status (true/false) of a delegation
  12. Retrieve function to get the status (true/false) of a delegation given a token id
  13. Retrieve function to check if the delegation address performing any actions is the most recently delegated one
  14. Retrieve function to check the status (true/false) of an active delegator on a given date
  15. Retrieve functions to get all the tokends ids as well as the expiry dates of a delegation address/delegator
  16. Retrieve function to get the most recent delegation address delegated on a specific usecase
  17. Retrieve function to get the most recent delegator given a delegation Address
  18. Function to support the subDelegation process
  19. Function to check if a Consolidation between 2 addresses exists
  20. Functions to retrieve the status of a Global/Collection/Collection&UseCase Lock
  21. Other functions that support smart contract's processes like retrieving of hashes etc.

## Free from Dependencies

The contract is free from any dependencies.

We took the design decision to implement core functionality and include it as part of the core contract without referring to any external libraries that could (potentially) introduce additional attack vectors or vulnerabilities outside our control; since these are maintained by teams that are outside the control scope of our core implementation. Therefore, we are adopting a self-contained contract philosophy.
