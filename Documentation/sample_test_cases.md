# NFT Delegation Smart Contract
## Sample Test Cases

[How to run the test cases?](#setupEnvironment)\
[Register a delegation address on The Memes by 6529 collection on various use cases](#registerDelegationAddressCollection)\
[Revoke a delegation address on The Memes by 6529 collection](#revokeDelegationAddress)\
[Update a delegation address on The Memes by 6529 collection](#updateDelegationAddress)\
[Register a delegation address using a wallet with subdelegation rights](#registerDelegationAddressUsingSubDelegation)\
[Revoke a delegation address using a wallet with subdelegation rights](#revokeDelegationAddressUsingSubdelegation)\
[Check the consolidation status of two addresses on a collection](#checkConsolidationStatus)\
[Retrieve Delegators who gave delegation rights to a delegation Address](#retrieveDelegators)\
[Using locks on a wallet address](#useLocks)

<div id='setupEnvironment'/>

## Setup workscape:

The simpliest configuration to run the sample test cases is via remix.org.

1. Navigate to remix.org
2. Under File Explorer click the Create New file icon
3. Name the file testCases.sol
4. Navigate to the src folder on the [nftdelegation repository](https://github.com/6529-Collections/nftdelegation/blob/main/src/DelegationManagement.sol)
5. Copy the source code and paste it on the newly created testCases.sol
6. Under Solidity compiler click Compile testCases.sol
7. Navigate to the Deploy & run transactions tab
8. Make sure that the Envrionment is set to Remix VM (Merge) and the Contract is set to delegationManagementContract
9. Click Deploy and then Force Send

If you followed the steps correctly you will be able to view all setter and getter functions of the smart contract.

You are always welcome to run the smart contract code and conduct the tests using other tools or direcly through etherscan.io on the Goerli contract.

<div id='registerDelegationAddressCollection'/>

## Register a delegation address on The Memes by 6529 collection on various use cases

### Description: In this group of test cases a wallet calls the registerDelegationAddress(...) function to register a delegation address. Please make sure that the  address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 is selected as an Account on remix and that you will use as a delegation Address an address that also exists on the Account dropdown box.

### Test Case ID: 1

***Test Case Objective:*** \
\
Register a delegation address on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for all use cases (1-15).\
\
***Prerequisite:***
1. Usecase number exists 
2. Delegation Address is not locked
<!-- end of the list -->

***Input Data for function registerDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 1\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 1 and the function will return the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddress(...) | 1 | The delegation will be registered. | The delegation was registered. | Pass


### Test Case ID: 2

***Test Case Objective:*** \
\
Register a delegation address on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the airdrop use case (#3) only and just for The Memes token #1.\
\
***Prerequisite:***
1. Use case number exists
2. Delegation Address is not locked
<!-- end of the list -->

***Input Data for function registerDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 3\
_allTokens = false\
_tokenid = 1

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 3 and the function will return the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddress(...) | 3 | The delegation will be registered. | The delegation was registered. | Pass

### Test Case ID: 3

Test Case Objective: Register a delegation address on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for use case number 50.\
\
***Prerequisite:***
1. Delegation Address is not locked
<!-- end of the list -->

***Input Data for function registerDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 50\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 50 and you will notice that the delegation was not registered.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddress(...) | 50 | The delegation will not be registered as the execution of the transaction will fail. | The delegation was not registered. | Pass

### Test Case ID: 4

Test Case Objective: Register a delegation address on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the sub-delegation rights use case #16.\
\
***Prerequisite:***
1. Use case exists
2. Delegation Address is not locked
<!-- end of the list -->

***Input Data for function registerDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 16\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 16 and the function will return the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddress(...) | 16 | The delegation will be registered. | The delegation was not registered. | Pass

### Test Case ID: 5

Test Case Objective: Register a delegation address on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for consolidation purposes use case #99.\
\
***Prerequisite:***
1. Use case exists
2. Delegation Address is not locked
<!-- end of the list -->

***Input Data for function registerDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 99\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 99 and the function will return the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddress(...) | 99 | The delegation will be registered. | The delegation was not registered. | Pass

<div id='revokeDelegationAddress'/>

## Revoke a delegation address from The Memes by 6529 collection

### Description: In this group of test cases a wallet calls the revokeDelegationAddress(...) function to revoke a delegation address. Please make sure that the  address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 is selected as an Account on remix and that you will revoke an address that was already registered for delegation.

### Test Case ID: 6

***Test Case Objective:*** \
\
Revoke a delegation address from 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) that was already registered for the airdrop usecase #3.\
\
***Prerequisite:***
1. Execute Test Case ID 2.
2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 3 and make sure that a delegation Address was registered for that specific use case. If you have already executed Test Case ID 2 you should be able to view as a result the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.
3. Usecase number exists 
4. Delegation Address was already registered
<!-- end of the list -->

***Input Data for function revokeDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_useCase = 3

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 3, you will notice that the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148 was revoked.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
revokeDelegationAddress(...) | 3 | The delegation will be revoked. | The delegation was revoked. | Pass

<div id='updateDelegationAddress'/>

## Update a delegation address from The Memes by 6529 collection

### Description: In this group of test cases a wallet calls the updateDelegationAddress(...) function to update a delegation address. Please make sure that the  address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 is selected as an Account on remix and that you will update an address that was already registered for delegation.

### Test Case ID: 7

***Test Case Objective:*** \
\
Update a delegation address from 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) that was already registered for all use cases #1.\
\
***Prerequisite:***
1. Execute Test Case ID 1.
2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 1 and make sure that a delegation Address was registered for that specific use case. If you have already executed Test Case ID 1 you should be able to view as a result the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.
3. Usecase number exists 
4. Delegation Address was already registered
<!-- end of the list -->

***Input Data for function updateDelegationAddress(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_olddelegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_newdelegationAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 1\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 1 and the function will return the updated delegation address 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
updateDelegationAddress(...) | 1 | The delegation will be updated. | The delegation was updated. | Pass

<div id='registerDelegationAddressUsingSubDelegation'/>

## Register a delegation address for The Memes by 6529 collection using a wallet that has sub-delegation rights

### Description: In this group of test cases a wallet calls the registerDelegationAddressUsingSubDelegation(...) function to register a delegation address on behalf of a Delegator that granted him/her sub-delegation rights.

### Test Case ID: 8

***Test Case Objective:*** \
\
Register a delegation address on behalf of a delegator on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for minting use case #2.\
\
***Prerequisite:***
1. Execute Test Case ID 4.
2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 16 and make sure that a delegation Address was registered for the sub-delegation usecase. If you have already executed Test Case ID 4 you should be able to view as a result the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.
3. Select the wallet address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148 from accounts.
4. Usecase number exists.
5. Delegation Address in not locked.
<!-- end of the list -->

***Input Data for function registerDelegationAddressUsingSubDelegation(...):***\
\
_delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB\
_expiryDate = 1682080764 (21/04/2023)\
_useCase = 2\
_allTokens = true\
_tokenid = 0

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 2 and the function will return the updated delegation address 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
registerDelegationAddressUsingSubDelegation(...) | 2 | The delegation will be registered. | The delegation was registered. | Pass

<div id='revokeDelegationAddressUsingSubdelegation'/>

## Revoke a delegation address from The Memes by 6529 collection using a wallet that has sub-delegation rights

### Description: In this group of test cases a wallet calls the revokeDelegationAddressUsingSubdelegation(...) function to revoke a delegation address on behalf of a Delegator that granted him/her sub-delegation rights.

### Test Case ID: 9

***Test Case Objective:*** \
\
Revoke a delegation address on behalf of a delegator on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for all use cases #1.\
\
***Prerequisite:***
1. Execute Test Case ID 1.
2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 1 and make sure that the function returns back delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.
3. Execute Test Case ID 4.
4. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 16 and make sure that a delegation Address was registered for the sub-delegation usecase. If you have already executed Test Case ID 4 you should be able to view as a result the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148.
5. Select the wallet address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148 from accounts.
6. Usecase number exists.
<!-- end of the list -->

***Input Data for function revokeDelegationAddressUsingSubdelegation(...):***\
\
_delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_delegationAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148\
_useCase = 1

***Post-execution:***\
\
Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 1, you will notice that the delegation address 0xdD870fA1b7C4700F2BD7f44238821C26f7392148 was revoked.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
revokeDelegationAddressUsingSubdelegation(...) | 1 | The delegation will be revoked. | The delegation was revoked. | Pass
    
<div id='checkConsolidationStatus'/>

## Check the consolidation status of two addresses on a collection

### Description: In this group of test cases a wallet can check the consolidation status of two addresses registered on a specific collection by calling the checkConsolidationStatus(...) function.

### Test Case ID: 10

***Test Case Objective:*** \
\
Check the consolidation status of two addresses. Firstly, you need to register wallet 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7 using wallet 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the consolidation use case #99. Secondly, register wallet 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 using wallet 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7 on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the consolidation use case #99. Finally, call the checkConsolidationStatus(...) function.\
\
***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 99\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 99 and make sure that the function returns back delegation address 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7.

3. Execute the registerDelegationAddress(...) function using the wallet account 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 99\
    _allTokens = true\
    _tokenid = 0

4. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 99 and make sure that the function returns back delegation address 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4.

<!-- end of the list -->

***Input Data for function checkConsolidationStatus(...):***\
\
_wallet1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4\
_wallet2 = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1


Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
checkConsolidationStatus(...) | 99 | Consolidation status will exist | Consolidation status exists | Pass

<div id='retrieveDelegators'/>

## Retrieve Delegators who gave delegation rights to a delegation Address

### Description: In this group of test cases a wallet can find out which wallets gave delegation rights (delegators) to a specific delegation address on a specific usecase on a collection by calling the retrieveDelegators(...) function. In addition, in test case 12 the retrieveActiveDelegators(...) function will be executed to find just the active delegator addresses. 

### Test Case ID: 11

***Test Case Objective:*** \
\
Find which addresses gave delegation rights to a specific wallet on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the voting/governance use case #4.\
\
***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 4\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 4 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

3. Execute the registerDelegationAddress(...) function using the wallet account 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 4\
    _allTokens = true\
    _tokenid = 0

4. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 4 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

<!-- end of the list -->

***Input Data for function retrieveDelegators(...):***\
\
_delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_useCase = 4

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
retrieveDelegators(...) | 4 | Function will return back 2 addresses | Function returns back 2 addresses | Pass
    
### Test Case ID: 12

***Test Case Objective:*** \
\
Find the active delegation addresses that gave delegation rights to a specific wallet on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address) for the Virtual Events Access use case #8 by calling the retrieveActiveDelegators(...) function.\
\
***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1679983329 (28/03/2023)\
    _useCase = 8\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 8 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

3. Execute the registerDelegationAddress(...) function using the wallet account 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 8\
    _allTokens = true\
    _tokenid = 0

4. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 8 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

<!-- end of the list -->

***Input Data for function retrieveActiveDelegators(...):***\
\
_delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_data = 1680328929 (01/04/2023)\
_useCase = 8

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
retrieveActiveDelegators(...) | 8 | Function will return back just the 0x03C6FcED...9D1Ff7 address. | Function returns back 0x03C6FcED...9D1Ff7 | Pass
    
<div id='useLocks'/>

## Retrieve Delegators who gave delegation rights to a delegation Address

### Description: In this group of test cases a wallet will make use of the setglobalLock(...), setcollectionLock(...), setcollectionUsecaseLock(...) functions to get familiar of how he/she can lock/unlock a wallet so thus it cannot accept any more delegations.

### Test Case ID: 13

***Test Case Objective:*** \
\
Use a global lock so as a wallet address does not accept any more delegations on any collection.\
\
***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 4\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 4 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

3. Select the wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from accounts

<!-- end of the list -->

***Input Data for function setGlobalLock(...):***\
\
_status = true

***Post-execution:***\
\
Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the registerDelegationAddress(...) using the same data as step 1 but using the 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 wallet from Accounts.\
Your transaction will fail as the address is locked globally.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
setGlobalLock(...) | 4 | Function will lock the address globally | Function locked the address | Pass

***Next steps:***\
\
Select wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from Accounts.\
Call the setGlobalLock(...) function with _status = false so as to unlock the address and move to the next Test Case.

### Test Case ID: 14

***Test Case Objective:*** \
\
Use a collection lock so as a wallet address does not accept any more delegations on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address).

***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 4\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 4 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

3. Select the wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from accounts

<!-- end of the list -->

***Input Data for function setCollectionLock(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_status = true

***Post-execution:***\
\
Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the registerDelegationAddress(...) using the same data as step 1.\
Your transaction will fail as the address is locked on this collection.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
setCollectionLock(...) | 4 | Function will lock the address on The Memes collection| Function locked the address on The Memes collection | Pass

***Next steps:***\
\
Select wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from Accounts.\
Call the setCollectionLock(...) function with _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 and _status = false so as to unlock it and move to the next Test Case.

### Test Case ID: 15

***Test Case Objective:*** \
\
Use a collection use case lock so as a wallet address does not accept any more delegations on a specific use case on 0x33FD426905F149f8376e227d0C9D3340AaD17aF1 (The Memes by 6529 collection address).

***Prerequisite:***
1. Execute the registerDelegationAddress(...) function using the wallet account 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 with the following input data: 

    _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
    _delegationAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB\
    _expiryDate = 1682080764 (21/04/2023)\
    _useCase = 10\
    _allTokens = true\
    _tokenid = 0

2. Call the retrieveDelegationAddresses(...) function with inputdata _delegatorAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 10 and make sure that the function returns back delegation address 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB.

3. Select the wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from accounts

<!-- end of the list -->

***Input Data for function setCollectionUsecaseLock(...):***\
\
_collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1\
_useCase = 10\
_status = true

***Post-execution:***\
\
Select wallet 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 from the Accounts.\
Execute the registerDelegationAddress(...) using the same data as step 1.\
Your transaction will fail as the address is locked on the specific use case on this collection.

Function | Use-Case  | Expected Output | Actual Output | Status
------------- | ------------- | ------------- | ------------- | -------------
setCollectionUsecaseLock(...) | 10 | Function will lock the address on use case #10 on The Memes collection| Function locked the address on use case #10 on The Memes collection | Pass

***Next steps:***\
\
Select wallet 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB from Accounts.\
Call the setCollectionUsecaseLock(...) function with _collectionAddress = 0x33FD426905F149f8376e227d0C9D3340AaD17aF1, _useCase = 10 and _status = false so as to unlock the address.
