## Purpose

This smart contract demonstrates how the NFTDelegation.com smart contract can be used on your own smart contract for making external calls.

### Steps

1. Import Interfaces within your smart contract
    ```ruby
    import "/INFTDelegationRead.sol";
    ```

2. Declare the Read Interface variable as below:
    ```ruby
    INFTDelegationRead public dmcRead;
    ```

2. Modify your contructor as below. When deploying the smart contract input the NFTDelegation smart contract address `0x2202CB9c00487e7e8EF21e6d8E914B32e709f43d` within your constructor.
    ```ruby
    constructor(address _NFTdelegationManagementContract) {
        dmcRead = INFTDelegationRead(_NFTdelegationManagementContract);
    }
    ```

3. Add function calls

    i. This function returns an array of all Delegators for the wallet address that calls the function based on 'Any Collection' and 'All Use Cases' .
    ```ruby
    function retrieveDelegators() public view returns(address[] memory) {
        return dmcRead.retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 1);
    }
    ```
    ii. This function checks the minting status for the wallet address that calls the function by providing a `vault wallet address`. This specific function is based on 'Any Collection' and 'Minting Use Case #2'.
    ```ruby
    function checkMintingStatus(address _vault) public view returns(bool) {
        return dmcRead.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 2);
    }
    ```

### Full Source Code

```ruby
//SPDX-License-Identifier: MIT

import "/INFTDelegationRead.sol";

pragma solidity ^0.8.18;

contract NFTDelegationDEMO {
    
    INFTDelegationRead public dmcRead;

    constructor(address _NFTdelegationManagementContract) {
        dmcRead = INFTDelegationRead(_NFTdelegationManagementContract);
    }

    // Sample function for retrieving the delegators of msg.sender on Any collection for Any Use case

    function retrieveDelegators() public view returns(address[] memory) {
        return dmcRead.retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 1);
    }

    // Sample function for retrieving the delegation status of msg.sender given a Delegator address

    function checkMintingStatus(address _vault) public view returns(bool) {
        return dmcRead.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 2);
    }

}
```
