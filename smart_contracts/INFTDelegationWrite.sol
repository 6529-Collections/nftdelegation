//SPDX-License-Identifier: MIT

/**
 * @dev Interface for all Setter functions (Write functions) of the NFTDelegation.com Smart Contract
 */

pragma solidity ^0.8.18;

interface INFTDelegationWrite {

    /**
     * @notice This function allows a Delegator to register a delegation address on a specific usecase on a certain collection
     */

    function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) external;

    /**
     * @notice This function allows a wallet address that has sub-delegation rights to register a delegation address on a specific usecase on a certain collection on behalf of a delegator
     */

    function registerDelegationAddressUsingSubDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) external;

    /**
     * @notice This function allows a Delegator to revoke a delegation address from a specific usecase for a certain collection
     */

    function revokeDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _useCase) external;

    /**
     * @notice This function allows a wallet address that has sub-delegation rights to revoke a delegation address from a specific usecase for a certain collection on behalf of a delegator
     */

    function revokeDelegationAddressUsingSubdelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) external;

    /**
     * @notice This function allows a Delegator to update a delegation address, already registered, on a specific use case on a certain collection
     */

    function updateDelegationAddress(address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) external;

    /**
     * @notice This function allows a Delegator to register up to 5 delegation addresses on various usecases on various collections
     */

    function batchDelegations(address[] memory _collectionAddresses, address[] memory _delegationAddresses, uint256[] memory _expiryDates, uint256[] memory _useCases, bool[] memory _allTokens, uint256[] memory _tokenIds) external;
    
    /**
     * @notice This function allows a Delegator to revoke up to 5 delegation addresses
     */

    function batchRevocations(address[] memory _collectionAddresses, address[] memory _delegationAddresses, uint256[] memory _useCases) external;

    /**
     * @notice This function allows a wallet address to be locked globally
     */

    function setGlobalLock(bool _status) external;

    /**
     * @notice This function allows a wallet address to be locked on a collection
     */

    function setCollectionLock(address _collectionAddress, bool _status) external;

    /**
     * @notice This function allows a wallet address to be locked on a specific use case on a collection
     */

    function setCollectionUsecaseLock(address _collectionAddress, uint256 _useCase, bool _status) external;

    /**
     * @notice This function allows a wallet address to update the number of use cases
     */

    function updateUseCaseCounter() external;

}