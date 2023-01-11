// SPDX-License-Identifier: MIT

/** 
 *
 *  @title: Delegation Management Contract   
 *  @date: 09-Jan-2022 @ 12:51
 *  @version: 5.13 - subDelegation features
 *  @notes: This is a experimental contract for delegation registry
 *  @modifications: Added global, collection and usecase locks, Added change/retrieve Lock status function
 *  @modifications: Updated revoke and update functions
 *  @modifications: Retrieve most recent addresses
 *  @modifications: Added tokens on register function
 *  @modifications: Retrieve tokenids delegated
 *  @modifications: Added batch registrations
 *  @modifications: Updated events list
 *  @author: skynet2030 (skyn3t2030)
 *  @credits: to be added ... 
 *
 */

pragma solidity ^0.8.17;

contract delegationManagement {

    // Variable declarations
    uint256 useCaseCounter; 

    // Mapping declarations
    mapping (bytes32 => address[]) public delegateToHashes;
    mapping (bytes32 => address[]) public delegateFromHashes;

    struct globalData {
        uint256 expiryDate;
        bool allTokens;
        uint256 tokens;
    }

    // Mapping of struct declarations
    mapping (bytes32 => globalData[]) public globalDataHashes;

    // Events declaration
    event registerDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase, uint8 lock, bool allTokens, uint256 _tokenid);
    event revokeDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase);
    event updateDelegation(address indexed from, address indexed collectionAddress, address olddelegationAddress, address indexed newdelegationAddress, uint8 useCase, uint8 lock, bool allTokens, uint256 _tokenid);
    
    //Global Registry for all collections & usecases history
    mapping (address => address[]) public CollectionsRegistered;
    mapping (address => uint256[]) public UseCaseRegistered;

    
    // Locks mapping declarations
    mapping (address => bool) public globalLock;
    mapping (bytes32 => bool) public collectionLock;
    mapping (bytes32 => bool) public collectionUsecaseLock;
    
    // Constructor
    constructor() {
        useCaseCounter = 15;
    }
  
    /**
     * @notice Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
     * @notice _collectionAddress --> 0x8888888888888888888888888888888888888888 = All collections
     * @notice For allTokens -- > _allTokens needs to be true, _tokenId does not matter
     * @notice 0 - unlock, 1 - collectionLock, 2 - collectionUsecaseLock, 3 - globalLock
     */

    function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint8 _useCase, uint8 _lock, bool _allTokens, uint256 _tokenid) public {
        require((_useCase >0 && _useCase < useCaseCounter) || (_useCase == 99));
        bytes32 toHash;
        bytes32 fromHash;
        bytes32 globalHash;
        bytes32 collectionLockHash;
        bytes32 collectionUsecaseLockHash;
        // Locks
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        require(globalLock[_delegationAddress] == false);
        require(collectionLock[collectionLockHash] == false);
        require(collectionUsecaseLock[collectionUsecaseLockHash] == false);
        // Push data to mappings
        globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        toHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        fromHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        delegateToHashes[toHash].push(_delegationAddress);
        delegateFromHashes[fromHash].push(msg.sender);
        // Optional to keep history
        CollectionsRegistered[msg.sender].push(_collectionAddress);
        CollectionsRegistered[_delegationAddress].push(_collectionAddress);
        UseCaseRegistered[msg.sender].push(_useCase);
        UseCaseRegistered[_delegationAddress].push(_useCase);
        // Push data to the globalData mapping
        if (_allTokens == true) {
        globalData memory newdelegationGlobalData = globalData(_expiryDate, true, 0);
        globalDataHashes[globalHash].push(newdelegationGlobalData);
        } else {
            globalData memory newdelegationGlobalData = globalData(_expiryDate, false, _tokenid);
            globalDataHashes[globalHash].push(newdelegationGlobalData);
        }
        // Lock choice for delegationAddress
        if (_lock == 1) {
            collectionLock[collectionLockHash] = true;
        } else if (_lock == 2) {
            collectionUsecaseLock[collectionUsecaseLockHash] = true;
        } else if (_lock ==3) {
            globalLock[_delegationAddress] = true;
        }
        // lock only one address for subdelegation
        if (_useCase == 14) {
            globalLock[_delegationAddress] = true;
        }
        emit registerDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase, _lock, _allTokens, _tokenid);
    }

    /**
     * @notice Delegator revokes delegation rights from a delagation address given to a specific use case on a specific NFT collection
     * @notice This function does not revoke from the CollectionsRegistered or UseCaseRegistered as we want to track history
     */
    
    function revokeDelegationAddress(address _collectionAddress, address _delegationAddress, uint8 _useCase) public {
        bytes32 toHash;
        bytes32 fromHash;
        bytes32 globalHash;
        uint256 count;
        globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        toHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        fromHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        // delete from toHashes mapping
        count=0;
        if (delegateToHashes[toHash].length>0) {
        for (uint256 i=0; i<=delegateToHashes[toHash].length-1; i++){
            if (_delegationAddress == delegateToHashes[toHash][i]) {
                count=count+1;
            }
        }
        uint256[] memory delegationsPerUser = new uint256[](count);
        uint256 count1=0;
        for (uint256 i=0; i<=delegateToHashes[toHash].length-1; i++){
            if (_delegationAddress == delegateToHashes[toHash][i]) {
                delegationsPerUser[count1] = i;
                count1=count1+1;
            }
        }
        if (count1>0) {
        for (uint256 j=0; j<=delegationsPerUser.length-1; j++) {
            uint256 temp1;
            uint256 temp2;
            temp1 = delegationsPerUser[delegationsPerUser.length-1-j];
            temp2 = delegateToHashes[toHash].length-1;
            delegateToHashes[toHash][temp1] = delegateToHashes[toHash][temp2];
            delegateToHashes[toHash].pop();
        }
        }
        // delete from fromHashes mapping
        uint256 countFrom=0;
        for (uint256 i=0; i<=delegateFromHashes[fromHash].length-1; i++){
            if (msg.sender == delegateFromHashes[fromHash][i]) {
                countFrom=countFrom+1;
            }
        }
        uint256[] memory delegationsFromPerUser = new uint256[](countFrom);
        uint256 countFrom1=0;
        for (uint256 i=0; i<=delegateFromHashes[fromHash].length-1; i++){
            if (msg.sender == delegateFromHashes[fromHash][i]) {
                delegationsFromPerUser[countFrom1] = i;
                countFrom1=countFrom1+1;
            }
        }
        if (countFrom1>0) {
        for (uint256 j=0; j<=delegationsFromPerUser.length-1; j++) {
            uint256 temp1;
            uint256 temp2;
            temp1 = delegationsFromPerUser[delegationsFromPerUser.length-1-j];
            temp2 = delegateFromHashes[fromHash].length-1;
            delegateFromHashes[fromHash][temp1] = delegateFromHashes[fromHash][temp2];
            delegateFromHashes[fromHash].pop();
        }
        }
        
        bytes32 collectionLockHash;
        bytes32 collectionUsecaseLockHash;
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        collectionLock[collectionLockHash] = false;
        collectionUsecaseLock[collectionUsecaseLockHash] = false;
        globalLock[_delegationAddress] = false;
        delete globalDataHashes[globalHash];
        emit revokeDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
        }
    }

    /**
     * @notice RevokeAll
     * @notice This function revokes everything and history cannot be tracked
     */

    function revokeAll() public returns (address[] memory){
        address[] memory allCollections = CollectionsRegistered[msg.sender];
        uint256[] memory allUseCases = UseCaseRegistered[msg.sender];
        address[] memory delegationAddresses;
        for (uint256 i=0; i<= allCollections.length-1; i++) {
            delegationAddresses = this.retrieveToDelegationAddressesPerUsecaseForCollection(msg.sender, allCollections[i], uint8(allUseCases[i]));
        if (delegationAddresses.length>0) {
        for (uint y=0; y<=delegationAddresses.length-1; y++) {
                revokeDelegationAddress(allCollections[i], delegationAddresses[y], uint8(allUseCases[i]));
            }
        }
        }
        for (uint256 x=0; x<=allCollections.length-1; x++) {
            CollectionsRegistered[msg.sender].pop();
            UseCaseRegistered[msg.sender].pop();
        }
        return (delegationAddresses);

    }

    /**
     * @notice Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
     * 
     */

    function updateDelegationAddress (address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint8 _useCase, uint8 _lock, bool _allTokens, uint256 _tokenid) public {
        revokeDelegationAddress(_collectionAddress, _olddelegationAddress, _useCase);
        registerDelegationAddress(_collectionAddress, _newdelegationAddress, _expiryDate, _useCase, _lock, _allTokens, _tokenid);
        emit updateDelegation(msg.sender, _collectionAddress, _olddelegationAddress, _newdelegationAddress, _useCase, _lock, _allTokens, _tokenid);
    }

    /**
     * @notice Batch Registrations
     * @notice Use locks during last registration
     */

    function batchRegisterDelegations (address[] memory _collectionAddress, address[] memory _newdelegationAddress, uint256[] memory _expiryDate, uint8[] memory _useCase, uint8[] memory _lock, bool[] memory _allTokens, uint256[] memory _tokenid) public {
        for (uint256 i=0; i<=_collectionAddress.length-1; i++) {
        registerDelegationAddress(_collectionAddress[i], _newdelegationAddress[i], _expiryDate[i], _useCase[i], _lock[i], _allTokens[i], _tokenid[i]);
        }
    }

    /**
     * @notice Set globalLock status from hot wallet
     */

     function setglobalLock(bool _status) public {
         globalLock[msg.sender] = _status;
     }

     /**
     * @notice Set collection Lock status from hot wallet
     */

     function setcollectionLock(address _collectionAddress, bool _status) public {
         bytes32 collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender));
         collectionLock[collectionLockHash] = _status;
     }

     /**
     * @notice Set collection usecase Lock status from hot wallet
     */

     function setcollectionUsecaseLock(address _collectionAddress, uint8 _useCase, bool _status) public {
         bytes32 collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender, _useCase));
         collectionUsecaseLock[collectionUsecaseLockHash] = _status;
     }

    // A full list of Available Getter functions

    /**
     * @notice Retrieve Global Lock Status
     */

    function retrieveGloballockStatus(address _delegationAddress) public view returns (bool) {
        return globalLock[_delegationAddress];
    }
    
     /**
     * @notice Retrieve Collection Lock Status
     */

    function retrieveCollectionLockStatus(address _collectionAddress, address _delegationAddress) public view returns (bool) {
        bytes32 collectionLockHash;
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        return collectionLock[collectionLockHash];
    }

     /**
     * @notice Retrieve Collection Use Case Lock Status
     */

    function retrieveCollectionUseCaseLockStatus(address _collectionAddress, address _delegationAddress, uint8 _useCase) public view returns (bool) {
        bytes32 collectionUsecaseLockHash;
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        return collectionUsecaseLock[collectionUsecaseLockHash];
    }

    /**
     * @notice Support function used to retrieve the hash given specific parameters
     */

    function retrieveLocalHash(address _profileAddress, address _collectionAddress, uint8 _useCase) public pure returns (bytes32) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        return (hash);
    }

    /**
     * @notice Support function used to retrieve the global hash given specific parameters
     */

    function retrieveGlobalHash(address _profileAddress1, address _profileAddress2, address _collectionAddress, uint8 _useCase) public pure returns (bytes32) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress1, _profileAddress2, _collectionAddress, _useCase));
        return (hash);
    }
    
    /**
     * @notice Returns an array of all delegation addresses (active AND inactive) set by a delegator for a specific use case on a specific NFT collection
     */

     function retrieveToDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        return (delegateToHashes[hash]);
    }

    /**
     * @notice Returns an array of all delegators (active AND inactive) for a specific use case on a specific NFT collection
     */

     function retrieveFromDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        return (delegateFromHashes[hash]);
    }

    /**
     * @notice Returns an array of all history given a wallet address
     */

     function retrieveHistory(address _profileAddress) external view returns (address[] memory, uint256[] memory ) {
        return (CollectionsRegistered[_profileAddress], UseCaseRegistered[_profileAddress]);
    }

    /**
     * @notice Returns the status of each delegations for a cold wallet
     * @notice false means that is not registered or it was revoked from the delegateToHashes mapping
     */

     function retrieveStatusOfToDelegation(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        if (delegateToHashes[hash].length >0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @notice Returns the status of each delegations for a hot wallet
     * @notice false means that is not registered or it was revoked from the delegateFromHashes mapping
     */

     function retrieveStatusOfFromDelegation(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        if (delegateFromHashes[hash].length >0) {
            return true;
        } else {
            return false;
        }
    }

    // Retrieve To Delegation 
    // This set of functions is used to retrieve info for a cold address




    // Retrieve From Delegation 
    // This set of functions is used to retrieve info for a hot wallet


    /**
     * @notice Returns an array of all token ids delegated from an address for a specific usecase on specific collection
     */
     function retrieveTokensIDsandExpiredDatesFromDelegation(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory) {
        address[] memory allFromDelegations = this.retrieveFromDelegationAddressesPerUsecaseForCollection(_profileAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allFromDelegations.length);
        uint256 count1 =0 ;
        uint256 count2 =0 ;
        uint256 k=0;
        for (uint256 i=0; i<=allFromDelegations.length-1; i++){
            globalHash = keccak256(abi.encodePacked(allFromDelegations[i], _collectionAddress, _profileAddress, _useCase));
            allGlobalHashes[count1] = globalHash;
            count1 = count1+1;
        }
        //delete duplicates!!!
        for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
            for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                if (allGlobalHashes[i] == allGlobalHashes[j]) {
                delete allGlobalHashes[i];
                }
            }
        }
        for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
            k = globalDataHashes[allGlobalHashes[i]].length + k;
        }
        //declare local arrays
        uint256[] memory tokensIDs = new uint256[](k);
        bool[] memory allTokens = new bool[](k);
        uint256[] memory allExpirations = new uint256[](k);
        for (uint256 y=0; y<=k-1; y++){
            if (globalDataHashes[allGlobalHashes[y]].length>0) {
                for (uint256 w=0; w<=globalDataHashes[allGlobalHashes[y]].length-1; w++){
                allExpirations[count2] = globalDataHashes[allGlobalHashes[y]][w].expiryDate;
                allTokens[count2] = globalDataHashes[allGlobalHashes[y]][w].allTokens;
                tokensIDs[count2] = globalDataHashes[allGlobalHashes[y]][w].tokens;
                count2 = count2 + 1;
            }
        }
        }
        return (allFromDelegations, allExpirations, allTokens, tokensIDs);
     }

    /**
     * @notice Returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection 
     *
    */

     function retrieveActiveFromDelegations(address _profileAddress, address _collectionAddress, uint256 _date, uint8 _useCase) external view returns (address[] memory) {
        address[] memory allFromDelegations = this.retrieveFromDelegationAddressesPerUsecaseForCollection(_profileAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allFromDelegations.length);
        uint256 count1 =0;
        uint256 count2 =0;
        uint256 count3 =0;
        uint256 k=0;
        for (uint256 i=0; i<=allFromDelegations.length-1; i++){
            globalHash = keccak256(abi.encodePacked(allFromDelegations[i], _collectionAddress, _profileAddress, _useCase));
            allGlobalHashes[count1] = globalHash;
            count1 = count1+1;
        }
        //delete duplicates!!!
        for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
        for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
            if (allGlobalHashes[i] == allGlobalHashes[j]) {
            delete allGlobalHashes[i];
            }
        }
        }
        for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                k = globalDataHashes[allGlobalHashes[i]].length + k;
        }
        //declare local array
        uint256[] memory allExpirations = new uint256[](k);
        for (uint256 y=0; y<=k-1; y++){
            if (globalDataHashes[allGlobalHashes[y]].length>0) {
                for (uint256 w=0; w<=globalDataHashes[allGlobalHashes[y]].length-1; w++){
                allExpirations[count2] = globalDataHashes[allGlobalHashes[y]][w].expiryDate;
                count2 = count2 + 1;
            }
        }
        }
        address[] memory allActive = new address[](allExpirations.length);
        for (uint256 y=0; y<=k-1; y++){
            if (allExpirations[y]>_date) {
                allActive[count3] = allFromDelegations[y];
                count3 = count3 + 1;
            }
        }
        return (allActive);
     }

    /**
     * @notice Returns the most recent delegator for a specific use case on a specific NFT collection 
     *
    */

     function retrieveMostRecentFromDelegations(address _profileAddress, address _collectionAddress, uint8 _useCase) external view returns (address) {
         address[] memory allFromDelegations = this.retrieveActiveFromDelegations(_profileAddress, _collectionAddress, 1, _useCase);
         return (allFromDelegations[allFromDelegations.length-1]);
     }

    /**
     * @notice Retrieve subDelegation 
     *
    */

    function retrieveSubDelegation(address _profileAddress, address _collectionAddress, uint8 _useCase) external view returns(address[] memory) {
        address[] memory allFromDelegations = this.retrieveFromDelegationAddressesPerUsecaseForCollection(_profileAddress, _collectionAddress, _useCase);
        bytes32 hash;
        uint8 subUsecase;
        uint8 count;
        subUsecase = 14;
        for (uint256 i=0; i<=allFromDelegations.length-1; i++) {
        hash = keccak256(abi.encodePacked(allFromDelegations[i], _collectionAddress, subUsecase));
            if (delegateFromHashes[hash].length > 0) {
                count = count + 1;
        }
        }
        address[] memory subDelegations = new address[](count);
        count = 0;
        for (uint256 y=0; y<=allFromDelegations.length-1; y++) {
        hash = keccak256(abi.encodePacked(allFromDelegations[y], _collectionAddress, subUsecase));
            if (delegateFromHashes[hash].length > 0) {
                subDelegations[count] = delegateFromHashes[hash][0];
                count = count + 1;
        }
        }
        return (subDelegations);
    }     
}