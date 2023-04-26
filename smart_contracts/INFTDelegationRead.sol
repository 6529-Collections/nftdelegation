//SPDX-License-Identifier: MIT

/**
 * @dev Interface for all Getter functions (Read functions) of the NFTDelegation.com Smart Contract
 */

pragma solidity ^0.8.18;

interface INFTDelegationRead {
    
    /**
     * @notice This function returns an array of all delegation addresses (active AND inactive) assigned by a delegator for a specific use case on a specific NFT collection
     */

    function retrieveDelegationAddresses(address _delegatorAddress, address _collectionAddress, uint256 _useCase) external view returns (address[] memory);
    
    /**
     * @notice This function returns an array of all delegators (active AND inactive) that delegated to a delegationAddress for a specific use case on a specific NFT collection
     */

     function retrieveDelegators(address _delegationAddress, address _collectionAddress, uint256 _useCase) external view returns (address[] memory);

     /**
     * @notice This function returns the most recent delegation address delegated on a specific use case on a specific NFT collection
     */

    function retrieveMostRecentDelegation(address _delegatorAddress, address _collectionAddress, uint256 _useCase) external view returns (address);

    /**
     * @notice This function returns the most recent delegator on a specific use case on a specific NFT collection for a delegation Address
     */

    function retrieveMostRecentDelegator(address _delegationAddress, address _collectionAddress, uint256 _useCase) external view returns (address);

    /**
     * @notice This function returns the status of a delegation for a delegator address and a delegation address
     */

    function retrieveGlobalStatusOfDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) external view returns (bool);

    /**
     * @notice This function returns the status of a delegation given the delegator address, the collection address, the delegation address as well as a specific token id
     */

    function retrieveTokenStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase, uint256 _tokenId) external view returns (bool);

    /**
     * @notice This function checks if the delegation address performing actions is the most recent delegated by the specific delegator
     */

    function retrieveStatusOfMostRecentDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) external view returns (bool);

     /**
     * @notice This function checks if a delegator granted subdelegation status to an Address
     */

    function retrieveSubDelegationStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress) external view returns (bool);

     /**
     * @notice This function checks the status of an active delegator for a delegation Address
     */

    function retrieveStatusOfActiveDelegator(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _date, uint256 _useCase) external view returns (bool);

    /**
     * @notice This function checks the Consolidation status between 2 addresses
     */

    function checkConsolidationStatus(address _wallet1, address _wallet2, address _collectionAddress) external view returns (bool);

    /**
     * @notice This function returns the Global Lock Status of an address
     */

    function retrieveGlobalLockStatus(address _delegationAddress) external view returns (bool);

    /**
     * @notice This function returns the Collection Lock Status of an address
     */

    function retrieveCollectionLockStatus(address _collectionAddress, address _delegationAddress) external view returns (bool);

    /**
     * @notice This function returns the Collection Use Case Lock Status of an address
     */

    function retrieveCollectionUseCaseLockStatus(address _collectionAddress, address _delegationAddress, uint256 _useCase) external view returns (bool);

    /**
     * @notice This function returns the status of a collection/delegation for a delegator
     */

    function retrieveDelegatorStatusOfDelegation(address _delegatorAddress, address _collectionAddress, uint256 _useCase) external view returns (bool);

    /**
     * @notice This function returns the status of a collection/delegation for a delegation address (hot wallet)
     */

    function retrieveDelegationAddressStatusOfDelegation(address _delegationAddress, address _collectionAddress, uint256 _useCase) external view returns (bool);

    /**
     * @notice This function returns all delegation addresses, expiry dates of delegations, if the delegations refer to all tokens and tokensids for a delegator address
     */

    function retrieveDelegationAddressesTokensIDsandExpiredDates(address _delegatorAddress, address _collectionAddress, uint256 _useCase) external view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory);

    /**
     * @notice This function returns an array of all active delegation addresses on a certain date for a specific use case on a specific NFT collection for a delegator address
     */

    function retrieveActiveDelegations(address _delegatorAddress, address _collectionAddress, uint256 _date, uint256 _useCase) external view returns (address[] memory);

    /**
     * @notice This function returns all delegator addresses, expiry dates of delegations, if the delegations refer to all tokens and tokensids for a delegator address
     */

    function retrieveDelegatorsTokensIDsandExpiredDates(address _delegationAddress, address _collectionAddress, uint256 _useCase) external view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory);

    /**
     * @notice This function returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection for a delegation address
     */

    function retrieveActiveDelegators(address _delegationAddress, address _collectionAddress, uint256 _date, uint256 _useCase) external view returns (address[] memory);

}