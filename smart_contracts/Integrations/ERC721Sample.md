## Purpose

This smart contract demonstrates how an ERC721 smart contract can integrate the NFTDelegation.com smart contract for making external calls during their minting.

### Steps

1. Import Interfaces within your smart contract
    ```ruby
    import "/INFTDelegationRead.sol";
    ```

2. Declare the Read Interface variable as below:
    ```ruby
    INFTDelegationRead public dmc;
    ```

3. Add a control mechanism as follows to check the minting process and block Delegators' addresses for minting more than 1 time if the Delegatee Address already minted on their behalf

    ```ruby
    mapping (address => bool) public checkDelegatorMints;
    ```

4. Modify your ERC721 contructor as below. When deploying the smart contract input the NFTDelegation smart contract address `0x2202CB9c00487e7e8EF21e6d8E914B32e709f43d` within your constructor.
    ```ruby
    constructor(address _delegationManagementContract, string memory name, string memory symbol) ERC721(name, symbol) {
        dmc = INFTDelegationRead(_delegationManagementContract);
    }
    ```

5. Suggested Options for minting

    Option A. Minting function modifications that takes into consideration retrieveDelegators() function from the NFTDelegation.com Smart Contract based on 'Any Collection' and 'All Use Cases'. In this Option minted tokens are sent to the Delegators' Addresses. Using this function a Delegatee Address can call it once and all tokens for all Delegators will be minted.
    ```ruby
    function mintTokensForAllDelegators() public payable {
        // add your minting requirements and control mechanisms
        // to use NFTDelegation.com Smart Contract please add the code below
        address[] memory dmcDelegators;
        // use the collection and use case that you would like to retrieve delegators, in this case is 'Any Collection' and 'All Use Cases'
        dmcDelegators = dmc.retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 1);
        // minting process
        for(uint i = 0; i <= dmcDelegators.length-1; i++) {
            uint mintIndex = totalSupply();
            // control mechanisms to prevent wallets on minting again using the same delegators addresses
            if (checkDelegatorMints[dmcDelegators[i]] == false) {
                _safeMint(dmcDelegators[i], mintIndex);
                checkDelegatorMints[dmcDelegators[i]] = true;
            } else {}
        }
    }
    ```
    Option B: Minting function modifications that takes into consideration the retrieveGlobalStatusOfDelegation() function from the NFTDelegation.com Smart Contract based on 'Any Collection' and 'All Use Cases'. In this Option the minted token is sent to the Delegators' Address. 
    ```ruby
    function mintTokensPerDelegator(address _vault) public payable {
        // add your minting requirements and control mechanisms
        // to use NFTDelegation.com Smart Contract please add the code below
        bool isAllowedToMint;
        // check if a delegation between msg.sender and the vault exists on a specific usecase and collection, in this case is 'Any Collection' and 'All Use Cases'
        isAllowedToMint = dmc.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 1);
        require(isAllowedToMint == true, "No delegation exists");
        // minting process
        uint mintIndex = totalSupply();
        // control mechanisms to prevent wallets on minting again using the delegator's address
        if (checkDelegatorMints[_vault] == false) {
            _safeMint(_vault, mintIndex);
            checkDelegatorMints[_vault] = true;
        } else  { 
                revert("Already Minted");
                }
    }
    ```
    Option C: Minting function modifications that takes into consideration the retrieveGlobalStatusOfDelegation() function from the NFTDelegation.com Smart Contract based on 'Any Collection' and 'All Use Cases'. In this Option the minted token is sent to the _mintToAddress. 
    ```ruby
    function mintTokensPerDelegatorOtherAddress(address _vault, address _mintToAddress) public payable {
        // add your minting requirements and control mechanisms
        // to use NFTDelegation.com Smart Contract please add the code below
        bool isAllowedToMint;
        // check if a delegation between msg.sender and the vault exists on a specific usecase and collection, in this case is 'Any Collection' and 'All Use Cases'
        isAllowedToMint = dmc.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 1);
        require(isAllowedToMint == true, "No delegation exists");
        // minting process
        uint mintIndex = totalSupply();
        // control mechanisms to prevent wallets on minting again using the delegator's address
        if (checkDelegatorMints[_vault] == false) {
            _safeMint(_mintToAddress, mintIndex);
            checkDelegatorMints[_vault] = true;
        } else  { 
                revert("Already Minted");
                }
    }
    ```

### Full Source Code

```ruby
//SPDX-License-Identifier: MIT

import "/ERC721.sol";
import "/Ownable.sol";
import "/INFTDelegationRead.sol";

pragma solidity ^0.8.5;

contract ERC721_sample is ERC721, Ownable {
        using SafeMath for uint256;

        // NFTDelegation.com contract declaration
        INFTDelegationRead public dmc;

        // Contol mechanism to check minting and not allow the same Delegatees to mint again
        mapping (address => bool) public checkDelegatorMints;

        constructor(address _delegationManagementContract, string memory name, string memory symbol) ERC721(name, symbol) {
            dmc = INFTDelegationRead(_delegationManagementContract);
        }

        /**
        * Minting function taking into consideration retrieveDelegators() function from the NFTDelegation.com Smart Contract
        * In this case the minted tokens are sent to the vault wallet addresses (Delegators Addresses)
        * To send the minted tokens to the hot wallet change _safeMint(dmcDelegators[i], mintIndex) to _safeMint(msg.sender, mintIndex);
        */

        function mintTokensForAllDelegators() public payable {
            // add your minting requirements and control mechanisms
            // to use NFTDelegation.com Smart Contract please add the code below
            address[] memory dmcDelegators;
            // use the collection and use case that you would like to retrieve delegators, in this case is 'Any Collection' and 'All Use Cases'
            dmcDelegators = dmc.retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 1);
            // minting process
            for(uint i = 0; i <= dmcDelegators.length-1; i++) {
                uint mintIndex = totalSupply();
                // control mechanisms to prevent wallets on minting again using the delegators addresses
                if (checkDelegatorMints[dmcDelegators[i]] == false) {
                    _safeMint(dmcDelegators[i], mintIndex);
                    checkDelegatorMints[dmcDelegators[i]] = true;
                } else {}
            }
        }

        /**
        * Minting function taking into consideration retrieveGlobalStatusOfDelegation() function from the NFTDelegation.com Smart Contract
        * In this case the minted token is sent to the vault wallet address, Deelgator's Address
        * To send the minted token to the hot wallet change _safeMint(_vault, mintIndex) --> _safeMint(msg.sender, mintIndex);
        */

        function mintTokensPerDelegator(address _vault) public payable {
            // add your minting requirements and control mechanisms
            // to use NFTDelegation.com Smart Contract please add the code below
            bool isAllowedToMint;
            // check if a delegation between msg.sender and the vault exists on a specific usecase and collection, in this case is 'Any Collection' and 'All Use Cases'
            isAllowedToMint = dmc.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 1);
            require(isAllowedToMint == true, "No delegation exists");
            // minting process
            uint mintIndex = totalSupply();
            // control mechanisms to prevent wallets on minting again using the delegator's address
            if (checkDelegatorMints[_vault] == false) {
                _safeMint(_vault, mintIndex);
                checkDelegatorMints[_vault] = true;
            } else  { 
                    revert("Already Minted");
                    }
        }

        /**
        * Minting function taking into consideration retrieveGlobalStatusOfDelegation() function from the NFTDelegation.com Smart Contract
        * In this case the minted token is sent to the _mintToAddress wallet address
        */

        function mintTokensPerDelegatorOtherAddress(address _vault, address _mintToAddress) public payable {
            // add your minting requirements and control mechanisms
            // to use NFTDelegation.com Smart Contract please add the code below
            bool isAllowedToMint;
            // check if a delegation between msg.sender and the vault exists on a specific usecase and collection, in this case is 'Any Collection' and 'All Use Cases'
            isAllowedToMint = dmc.retrieveGlobalStatusOfDelegation(_vault, 0x8888888888888888888888888888888888888888, msg.sender, 1);
            require(isAllowedToMint == true, "No delegation exists");
            // minting process
            uint mintIndex = totalSupply();
            // control mechanisms to prevent wallets on minting again using the delegator's address
            if (checkDelegatorMints[_vault] == false) {
                _safeMint(_mintToAddress, mintIndex);
                checkDelegatorMints[_vault] = true;
            } else  { 
                    revert("Already Minted");
                    }
        }

    }
```
