# Delegation Management


#### Deployment
Network  | Contract Address
------------- | -------------
Goerli Testnet  | [0xFa8f9C0EBD0a2cEA53dfa3c2485e1a8648CaB59e](https://goerli.etherscan.io/address/0xfa8f9c0ebd0a2cea53dfa3c2485e1a8648cab59e)

- Deployer Address: 0xA63858Ace9838a457139c26886a2d155Cc3dFc2e
- Contract created on Goerli during TxHash# [0x60edeff57d35cd850650ad676cad5280e3e9a2c949332d5d09de4a8ebdceac84](https://goerli.etherscan.io/tx/0x60edeff57d35cd850650ad676cad5280e3e9a2c949332d5d09de4a8ebdceac84)

#### What is it?
Simply put, the proposed contract implementation deploys a "Delegation Management" that exists purely on-chain. This means that all data and their provenance are part of the contract's state.

#### Purpose

- It is often the case that wallet owners wish to assign delegation rights (in this context let's refer to assigners as "Delegators") to some other wallet address to act on their behalf. 
- A Delegator can assign a delegation address for a specific use case on a specific NFT collection for a certain duration.
- We note that the action of "delegation" does not assign any ownership (including its assets) on the Delegator's wallet. 

#### Use Cases

Use-Case  | Action
------------- | -------------
1  | All (1-14)
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
15 | Sub-delegation 
99 | Consolidation

#### Why is delegation useful?

- Interacting with dApps often requires signing of messages for performing certain operations. Accidentally signing a malicious transaction can authorize access to your assets.
- Delegation assignments make sense in cases where it is extremely risky to connect and sign messages from a cold wallet that is used for storing valuable fungible or non-fungible assets. Delegation addresses can be used to represent a Delegator and act on the Delegator's behalf under certain actions:

- An action could be:
    1. claiming token airdrops
    2. minting tokens from collections that require an entry to their allowlist(s)
    3. verifying/proving token ownership e.g., apps that implement some token gated policy
    4. or any other activity that relates to the above use-cases
&nbsp;
- Overall, this contract proposal is useful for use-cases where dApps require a global, on-chain registry that maps the "delegation" relationship between wallet addresses. 
	
#### Features

- Current implementation enables the following functionality:
    1. Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
	2. Delegator revokes delegation rights from a delagation address given a specific use case on a specific NFT collection
	3. Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
	4. Returns an array of all delegation addresses (active AND inactive) set by a delegator for a specific use case on a specific NFT collection
	5. Returns an array of all delegators (active AND inactive) for a specific use case on a specific NFT collection
	6. Returns an array of all active delegations on a certain date for a specific use case on a specific NFT collection
	7. Returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection

#### Free from Dependencies

- The contract is free from any dependencies. We took the design decision to implement core functionality and include it as part of the core contract without referring to any external libraries that could (potentially) introduce additional attack vectors or vulnerabilities outside our control; since these are maintained by teams that are outside the control scope of our core implementation. Therefore, we are adopting a self-contained contract philosophy.
