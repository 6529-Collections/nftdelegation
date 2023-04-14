# NFT Delegation Smart Contract

This smart contract provides many features to handle a wide variety of wallet delegation scenarios. To clarify how it's used, and allow for community validation, these example scenarios are provided with test cases.

Please contribute to this effort by running test test cases on your own, and reporting your results back to the team.

## Setup Workscape

The simplest approach to run these sample test cases is via the online solidity editor, Remix.

1. Navigate to [remix.ethereum.org](https://remix.ethereum.org/).
1. Create a new Workspace, from a "Blank" template, named something like "NFT Delegation Tests".
1. Under File Explorer click the "Create New File" icon: 📄.
1. Name the file `testCases.sol`
1. Navigate to the smart contract code, in the `src` folder on the [nftdelegation repository](https://github.com/6529-Collections/nftdelegation/blob/main/src/DelegationManagement.sol)
1. Copy the source code and paste it into your newly-created `testCases.sol` editor pane. Accept the warning about pasted code.
1. Navigate to the "Solidity compiler" side tab. Click "Compile testCases.sol"
1. You may see a warning about the size of the contract. You can disregard this, as it does not affect the testing process (or you can enable the optimizer under "Advanced Configurations", with a value of `200`, and recompile).
1. Navigate to the "Deploy & run transactions" side tab.
1. Make sure that the Envrionment is set to "Remix VM (Merge)" and the Contract is set to `DelegationManagementContract - testCases.sol`
1. Click "Deploy" (and then "Force Send" if you get a warning about contract size).

If you followed the steps correctly, you'll see the contract appear under "Deployed Contracts". By toggling the ">" next to the contract name, you will be able to view all the setter (in red) and getter (in blue) functions of the smart contract.

Use the dropdown arrow at the end of each function row to add arguments and invoke the function. The contract execution log will show in the Remix terminal for every function invocation. Use the dropdown there to see the details of the function call, and look in "decoded output" for the expected values.

You are always welcome to run the smart contract code and conduct the tests using other tools, or direcly through <https://etherscan.io> on the Sepolia contract (see the [README](../README.md) for testnet deployment details).

## Scenarios

For all scenarios, we will use "The Memes by 6529" as the NFT collection in the example tests. This collection's mainnet address is `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`. We will refer to it as The Collection.

Each scenario has various setup prerequisites, test cases, and potential reset steps to follow when complete.

1. [Register a delegation address on the collection, with various use cases](#register-a-delegation)
2. [Revoke a delegation address on the collection](#revoke-a-delegation)
3. [Update a delegation address on the collection](#update-a-delegation)
4. [Register a delegation address using a wallet with subdelegation rights](#register-a-delegation-with-sub-delegation-rights)
5. [Revoke a delegation address using a wallet with subdelegation rights](#revoke-a-delegation-with-sub-delegation-rights)
6. [Check the consolidation status of two addresses on a collection](#check-consolidation-status)
7. [Retrieve Delegators who gave delegation rights to a delegation Address](#retrieve-delegators)
8. [Using locks on a wallet address](#using-locks)

### Register a delegation

Any given ethereum wallet may wish to delegate certain behaviors to another wallet address, for purposes specific to a collection, and specific to a certain use-case.

In this group of test cases, a delegator wallet calls the `registerDelegationAddress()` function to register a delegation address.

Please make sure that the address `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` is selected as the "Account" on Remix, and that you will use as a delegation Address a different address from the Account dropdown box.

#### Test Case ID: 1

##### Objective

Register a delegation address on The Collection for **all** use cases (1-15).

##### Prerequisites

1. Use case number exists (a use case of `1` represents "all" use cases).
2. Delegation Address is not locked.

##### Invoke the test

Call the function `registerDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `1`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the function `retrieveDelegationAddresses()` with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `1`

We expect the function will return the delegated address, `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddress()` | 1 | The delegation will be registered. | The delegation was registered. | Pass

#### Test Case ID: 2

##### Objective

Register a delegation address for the airdrop use case (#3), but only for token #42 of The Collection.

##### Prerequisites

1. Use case number exists.
2. Delegation Address is not locked.

##### Invoke the test

Call the function `registerDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `3`
- _allTokens: `false`
- _tokenid: `42`

##### Validate the test

Call the function `retrieveDelegationAddresses()` with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `3`

 We expect the function will return the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddress()` | `3` | The delegation will be registered. | The delegation was registered. | Pass

#### Test Case ID: 3

##### Objective

Register a delegation address on The Collection for use case number 50.

##### Prerequisites

1. Delegation Address is not locked

##### Invoke the test

Call the function `registerDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `50`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `50` and you will notice that the delegation was not registered.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddress()` | `50` | The delegation will not be registered as the execution of the transaction will fail. | The delegation was not registered. | Pass

#### Test Case ID: 4

##### Objective

Register a delegation address on The Collection for the sub-delegation rights use case 998.

##### Prerequisites

1. Use case exists
2. Delegation Address is not locked

##### Invoke the test

Call the function `registerDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `998`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `998`

We expect the function will return the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddress()` | `998` | The delegation will be registered. | The delegation was registered. | Pass

#### Test Case ID: 5

##### Objective

Register a delegation address on The Collection for consolidation purposes use case #999.

##### Prerequisites

1. Use case exists
2. Delegation Address is not locked

##### Invoke the test

Call the function `registerDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `999`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `999`

We expect the function will return the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddress()` | `999` | The delegation will be registered. | The delegation was registered. | Pass

### Revoke a delegation

Delegations are not permanent. In this example, we will revoke the delegation of an address from The Collection

In this group of test cases, a wallet calls the `revokeDelegationAddress()` function to revoke a delegation address. Please make sure that the address `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` is selected as an Account on remix and that you will revoke an address that was already registered for delegation.

#### Test Case ID: 6

##### Objective

Revoke a delegation address from The Collection that was already registered for the airdrop (use case 3).

##### Prerequisites

1. Execute Test Case ID 2.
2. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `3`; ensure that a delegation Address was registered for that specific use case. If you have already executed Test Case ID 2 you should be able to view as a result the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`

3. Use case number exists
4. Delegation Address was already registered

##### Invoke the test

Call the function `revokeDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _useCase: 3

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `3`, you will notice that the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148` was revoked.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`revokeDelegationAddress()` | `3` | The delegation will be revoked. | The delegation was revoked. | Pass

### Update a delegation

Sometimes, delegations need to be updated.

In this group of test cases a wallet calls the `updateDelegationAddress()` function to update a delegation address. Please make sure that the address `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` is selected as an Account on remix and that you will update an address that was already registered for delegation.

#### Test Case ID: 7

##### Objective

Update a delegation address from The Collection that was already registered for all use cases 1.

##### Prerequisites

1. Execute Test Case ID 1.
2. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `1`; ensure that a delegation Address was registered for that specific use case. If you have already executed Test Case ID 1 you should be able to view as a result the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

3. Use case number exists
4. Delegation Address was already registered

##### Invoke the test

Call the function `updateDelegationAddress()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _olddelegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _newdelegationAddress: `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `1`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `1`

We expect the function will return the updated delegation address `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`updateDelegationAddress()` | `1` | The delegation will be updated. | The delegation was updated. | Pass

### Register a delegation with sub-delegation rights

In this example, we will register a delegation address for The Collection using a wallet that has sub-delegation rights.

In this group of test cases a wallet calls the `registerDelegationAddressUsingSubDelegation()` function to register a delegation address on behalf of a Delegator that granted him/her sub-delegation rights

#### Test Case ID: 8

##### Objective

Register a delegation address on behalf of a delegator on The Collection for minting use case #2.

##### Prerequisites

1. Execute Test Case ID 4.
2. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `998`; ensure that a delegation Address was registered for the sub-delegation use case. If you have already executed Test Case ID 4 you should be able to view as a result the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

3. Select the wallet address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148` from accounts.
4. Use case number exists.
5. Delegation Address in not locked.

##### Invoke the test

Call the function `registerDelegationAddressUsingSubDelegation()` with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB`
- _expiryDate: `1682080764` (21 Apr 2023)
- _useCase: `2`
- _allTokens: `true`
- _tokenid: `0`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `2`

We expect the function will return the updated delegation address `0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`registerDelegationAddressUsingSubDelegation()` | 2 | The delegation will be registered. | The delegation was registered. | Pass

### Revoke a delegation with sub-delegation rights

In this example, we will revoke a delegation from The Collection using a wallet that has sub-delegation rights.

In this group of test cases, a wallet calls the `revokeDelegationAddressUsingSubdelegation()` function to revoke a delegation address on behalf of a Delegator that granted him/her sub-delegation rights

#### Test Case ID: 9

##### Objective

Revoke a delegation address on behalf of a delegator on The Collection for all use cases #1.

##### Prerequisites

1. Execute Test Case ID 1.
2. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: 1; ensure that the function returns back delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`

3. Execute Test Case ID 4.
4. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `998`; ensure that a delegation Address was registered for the sub-delegation use case. If you have already executed Test Case ID 4 you should be able to view as a result the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`.

5. Select the wallet address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148` from accounts.
6. Use case number exists.

##### Invoke the test

Call the function `revokeDelegationAddressUsingSubdelegation()` with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _delegationAddress: `0xdD870fA1b7C4700F2BD7f44238821C26f7392148`
- _useCase: `1`

##### Validate the test

Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: 1, you will notice that the delegation address `0xdD870fA1b7C4700F2BD7f44238821C26f7392148` was revoked.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`revokeDelegationAddressUsingSubdelegation()` | `1` | The delegation will be revoked. | The delegation was revoked. | Pass

### Check consolidation status

Consolidation status of two addresses on a collection can be easily checked at any time.

In this group of test cases, a wallet will check the consolidation status of two addresses registered on a specific collection by calling the `checkConsolidationStatus()` function

#### Test Case ID: 10

##### Objective

Check the consolidation status of two addresses. Firstly, you need to register wallet `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7` using wallet `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` on The Collection for the consolidation use case #99. Secondly, register wallet `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` using wallet `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7` on The Collection for the consolidation use case #99. Finally, call the `checkConsolidationStatus()` function.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `999`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `999`; ensure that the function returns back delegation address `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`

3. Execute the `registerDelegationAddress()` function using the wallet account `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `999`
    - _allTokens: `true`
    - _tokenid: `0`

4. Call the `retrieveDelegationAddresses()` function with the following inputs:

    - _delegatorAddress: `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `999`; ensure that the function returns back delegation address `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.

##### Invoke the test

Call the function `checkConsolidationStatus()` with the following inputs:

- _wallet1: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _wallet2: `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`checkConsolidationStatus()` | `999` | Consolidation status will exist | Consolidation status exists | Pass

### Retrieve delegators

It's possible to see who gave delegation rights to a delegation address.

In this group of test cases a wallet can find out which wallets gave delegation rights (delegators) to a specific delegation address on a specific use case on a collection by calling the `retrieveDelegators()` function. In addition, in Test Case 12 the `retrieveActiveDelegators()` function will be executed to find just the active delegator addresses.

#### Test Case ID: 11

##### Objective

Find which addresses gave delegation rights to a specific wallet on The Collection for the voting/governance use case 4.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `4`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `4`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

3. Execute the `registerDelegationAddress()` function using the wallet account `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `4`
    - _allTokens: `true`
    - _tokenid: `0`

4. Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `4`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

##### Invoke the test

Call the function `retrieveDelegators()` with the following inputs:

- _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `4`

We expect the function will return the addresses `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` and `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`retrieveDelegators()` | `4` | Function will return back 2 addresses | Function returns back 2 addresses | Pass

#### Test Case ID: 12

##### Objective

Find the active delegation addresses that gave delegation rights to a specific wallet on The Collection for the Virtual Events Access use case #8 by calling the `retrieveActiveDelegators()` function.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: 1679983329 (28/03/2023)
    - _useCase: `8`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `8`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

3. Execute the `registerDelegationAddress()` function using the wallet account `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `8`
    - _allTokens: `true`
    - _tokenid: `0`

4. Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `8`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`.

##### Invoke the test

Call the function `retrieveActiveDelegators()` with the following inputs:

- _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _data: `1680328929` (01 Apr 2023)
- _useCase: `8`

We expect the function will return the address `0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7`.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`retrieveActiveDelegators()` | `8` | Function will return back just the 0x03C6FcED...9D1Ff7 address. | Function returns back 0x03C6FcED...9D1Ff7 | Pass

### Using locks

In this group of test cases a wallet will make use of the `setglobalLock()`, `setcollectionLock()`, `setcollectionUsecaseLock()` functions to lock/unlock a wallet, so that it cannot accept any more delegations.

#### Test Case ID: 13

##### Objective

Use a global lock so as a wallet address does not accept any more delegations on any collection.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `4`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with the following inputs:
    - _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _useCase: `4`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

3. Select the wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from accounts

##### Invoke the test

Call the function `setGlobalLock()` with the following inputs:

- _status: `true`

##### Validate the test

Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the `registerDelegationAddress()` using the same data as step 1.\
Your transaction will fail as the address is locked globally.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`setGlobalLock()` | `4` | Function will lock the address globally | Function locked the address | Pass

##### Next steps

Select wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from Accounts.

Call the `setGlobalLock()` function with:

- _status: `false`

so as to unlock it and move to the next Test Case.

#### Test Case ID: 14

##### Objective

Use a collection lock so as a wallet address does not accept any more delegations on The Collection.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `4`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with inputdata

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `4`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

3. Select the wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from accounts

##### Invoke the test

Call the function `setCollectionLock()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _status: `true`

##### Validate the test

Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the `registerDelegationAddress()` using the same data as step 1.\
Your transaction will fail as the address is locked on this collection.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`setCollectionLock()` | `4` | Function will lock the address on The Memes collection| Function locked the address on The Memes collection | Pass

##### Next steps

Select wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from Accounts.

Call the `setCollectionLock()` function with:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _status: `false`

so as to unlock it and move to the next Test Case.

#### Test Case ID: 15

##### Objective

Use a collection use case lock so as a wallet address does not accept any more delegations on a specific use case on The Collection.

##### Prerequisites

1. Execute the `registerDelegationAddress()` function using the wallet account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` with the following input data:

    - _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
    - _delegationAddress: `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`
    - _expiryDate: `1682080764` (21 Apr 2023)
    - _useCase: `10`
    - _allTokens: `true`
    - _tokenid: `0`

2. Call the `retrieveDelegationAddresses()` function with the following inputs:

- _delegatorAddress: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `10`; ensure that the function returns back delegation address `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB`

3. Select the wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from accounts

##### Invoke the test

Call the function `setCollectionUsecaseLock()` with the following inputs:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `10`
- _status: `true`

##### Validate the test

Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the `registerDelegationAddress()` using the same data as step 1.\
Your transaction will fail as the address is locked on the specific use case on this collection.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
`setCollectionUsecaseLock()` | `10` | Function will lock the address on use case #10 on The Memes collection| Function locked the address on use case #10 on The Memes collection | Pass

##### Next steps

Select wallet `0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB` from Accounts.

Call the `setCollectionUsecaseLock()` function with:

- _collectionAddress: `0x33FD426905F149f8376e227d0C9D3340AaD17aF1`
- _useCase: `10`
- _status: `false`

so as to unlock the address.
