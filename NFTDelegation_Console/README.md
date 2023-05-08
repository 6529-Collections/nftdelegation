# Install

  Create a new folder NFTDelegation_Console
  
  Download NFTDelegation.js and NFTdelegationABI.js
  
  Open terminal --> Locate path 

  ```
  npm i web3
  ```

# Add infura.io API KEY

  Open NFTDelegation.js

  Add you own infura.io API Key
  
  ```
  https://mainnet.infura.io/v3/<API KEY>
  ```
  
 # Open Console
 
  Run Syntax
  
  ```
  node NFTDelegation.js [functionCall] [address] [collection] [usecase]
  ```
  
  Retrieve Delegation Addresses
  
  ```
  node NFTDelegation.js retrieveDelegationAddresses address collection usecase
  ```
  
  Retrieve Delegators
  
  ```
  node NFTDelegation.js retrieveDelegators address collection usecase
  ```
  
## Currently Supported Functions

functionCall | Smart Contract function
------------- | -------------
retrieveDelegationAddresses  | retrieveDelegationAddresses
retrieveDelegationAddressesInfo | retrieveDelegationAddressesTokensIDsandExpiredDates
retrieveDelegators | retrieveDelegators
retrieveDelegatorsInfo | retrieveDelegatorsTokensIDsandExpiredDates
