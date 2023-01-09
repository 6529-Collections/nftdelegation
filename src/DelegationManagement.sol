// SPDX-License-Identifier: MIT

/** 
 *
 *  @title: Delegation Management Contract   
 *  @date: 05-Jan-2022 @ 13:12
 *  @version: 4.33 
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
    mapping (bytes32 => bool) public registeredDelegation;
    mapping (bytes32 => uint8) public delegationToCounterPerHash;
    mapping (bytes32 => uint8) public delegationFromCounterPerHash;

    // Struct declaration
    struct delegationAddresses {
        address mainAddress;
        bytes32 delegationGlobalHash;
        bytes32 delegationToHash;
        bytes32 delegationFromHash;
        address collectionAddress;
        address delegationAddress;
        uint256 registeredDate;
        uint256 expiryDate;
        uint8 useCase;
        int256 tokens;
    }

    // Mapping of struct declarations
    mapping (bytes32 => delegationAddresses[]) public delegateToHashes;
    mapping (bytes32 => delegationAddresses[]) public delegateFromHashes;

    // Events declaration

    event registerDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase, uint8 lock, int256 _tokenid);
    event revokeDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase);
    event updateDelegation(address indexed from, address indexed collectionAddress, address olddelegationAddress, address indexed newdelegationAddress, uint8 useCase, uint8 lock, int256 _tokenid);
    
    
    // Locks declarations

    mapping (address => bool) public globalLock;
    mapping (bytes32 => bool) public collectionLock;
    mapping (bytes32 => bool) public collectionUsecaseLock;
    
    // Constructor
    constructor() {
        useCaseCounter = 15;
    }
  
    /**
     * @notice Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
     * @notice 0x8888888888888888888888888888888888888888 = All collections
     * @notice tokenid = -1 ALL
     * @notice 0 - unlock, 1 - collectionLock, 2 - collectionUsecaseLock, 3 - globalLock
     */
    function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint8 _useCase, uint8 _lock, int256 _tokenid) public {
        require((_useCase >0 && _useCase < useCaseCounter) || (_useCase == 99));
        bytes32 toHash;
        bytes32 fromHash;
        bytes32 globalHash;
        bytes32 collectionLockHash;
        bytes32 collectionUsecaseLockHash;
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        require(globalLock[_delegationAddress] == false);
        require(collectionLock[collectionLockHash] == false);
        require(collectionUsecaseLock[collectionUsecaseLockHash] == false);
        globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        toHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        fromHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        delegationAddresses memory newdelegationAddress = delegationAddresses(msg.sender, globalHash, toHash, fromHash, _collectionAddress, _delegationAddress, block.timestamp, _expiryDate, _useCase, _tokenid);
        delegateToHashes[toHash].push(newdelegationAddress);
        delegateFromHashes[fromHash].push(newdelegationAddress);
		delegationToCounterPerHash[toHash] = delegationToCounterPerHash[toHash] + 1;
        delegationFromCounterPerHash[fromHash] = delegationFromCounterPerHash[fromHash] + 1;
        if (_lock == 1) {
            collectionLock[collectionLockHash] = true;
        } else if (_lock == 2) {
            collectionUsecaseLock[collectionUsecaseLockHash] = true;
        } else if (_lock ==3) {
            globalLock[_delegationAddress] = true;
        }
        emit registerDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase, _lock, _tokenid);
    }

    /**
     * @notice Delegator revokes delegation rights from a delagation address given to a specific use case on a specific NFT collection
     * 
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
        for (uint256 i=0; i<=delegationToCounterPerHash[toHash]-1; i++){
            if (globalHash == delegateToHashes[toHash][i].delegationGlobalHash) {
                count=count+1;
            }
        }
        uint256[] memory delegationsPerUser = new uint256[](count);
        uint256 count1=0;
        for (uint256 i=0; i<=delegationToCounterPerHash[toHash]-1; i++){
            if (globalHash == delegateToHashes[toHash][i].delegationGlobalHash) {
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
            delegationToCounterPerHash[toHash] = delegationToCounterPerHash[toHash] - 1;
        }
        }
        // delete from fromHashes mapping
        uint256 countFrom=0;
        for (uint256 i=0; i<=delegationFromCounterPerHash[fromHash]-1; i++){
            if (globalHash == delegateFromHashes[fromHash][i].delegationGlobalHash) {
                countFrom=countFrom+1;
            }
        }
        uint256[] memory delegationsFromPerUser = new uint256[](countFrom);
        uint256 countFrom1=0;
        for (uint256 i=0; i<=delegationFromCounterPerHash[fromHash]-1; i++){
            if (globalHash == delegateFromHashes[fromHash][i].delegationGlobalHash) {
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
            delegationFromCounterPerHash[fromHash] = delegationFromCounterPerHash[fromHash] - 1;
        }
        
        }
        bytes32 collectionLockHash;
        bytes32 collectionUsecaseLockHash;
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        collectionLock[collectionLockHash] = false;
        collectionUsecaseLock[collectionUsecaseLockHash] = false;
        globalLock[_delegationAddress] = false;
        emit revokeDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
    }

    /**
     * @notice Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
     * 
     */
    function updateDelegationAddress (address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint8 _useCase, uint8 _lock, int256 _tokenid) public {
        revokeDelegationAddress(_collectionAddress, _olddelegationAddress, _useCase);
        registerDelegationAddress(_collectionAddress, _newdelegationAddress, _expiryDate, _useCase, _lock, _tokenid);
        emit updateDelegation(msg.sender, _collectionAddress, _olddelegationAddress, _newdelegationAddress, _useCase, _lock, _tokenid);
    }

    /**
     * @notice Batch Registrations - use locks on last registration
     * 
     */

    function batchRegisterDelegations (address[] memory _collectionAddress, address[] memory _newdelegationAddress, uint256[] memory _expiryDate, uint8[] memory _useCase, uint8[] memory _lock, int256[] memory _tokenid) public {
        for (uint256 i=0; i<=_collectionAddress.length-1; i++) {
        registerDelegationAddress(_collectionAddress[i], _newdelegationAddress[i], _expiryDate[i], _useCase[i], _lock[i], _tokenid[i]);
        }
    }

    /**
     * @notice Set globalLock status
     */

     function setglobalLock(bool _status) public {
         globalLock[msg.sender] = _status;
     }

     /**
     * @notice Set collection Lock status
     */

     function setcollectionLock(address _collectionAddress, bool _status) public {
         bytes32 collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender));
         collectionLock[collectionLockHash] = _status;
     }

     /**
     * @notice Set collection usecase Lock status
     */

     function setcollectionUsecaseLock(address _collectionAddress, uint8 _useCase, bool _status) public {
         bytes32 collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender, _useCase));
         collectionUsecaseLock[collectionUsecaseLockHash] = _status;
     }

    // Getter functions

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
     * 
     */
    function retrieveHash(address _profileAddress, address _collectionAddress, uint8 _useCase) public pure returns (bytes32) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress,_collectionAddress,_useCase));
        return (hash);
    }
    
    /**
     * @notice Returns an array of all delegation addresses (active AND inactive) set by a delegator for a specific use case on a specific NFT collection
     * 
     */
     function retrieveToDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationToCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateToHashes[hash].length-1; i++){
            if (hash == delegateToHashes[hash][i].delegationToHash) {
                allDelegations[count] = delegateToHashes[hash][i].delegationAddress;
                count=count+1;
            }
        }
        return (allDelegations);
    }

    /**
     * @notice Returns an array of all delegators (active AND inactive) for a specific use case on a specific NFT collection
     *
     */
     function retrieveFromDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationFromCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateFromHashes[hash].length-1; i++){
            if (hash == delegateFromHashes[hash][i].delegationFromHash) {
                allDelegations[count] = delegateFromHashes[hash][i].mainAddress;
                count=count+1;
            }
        }
        return (allDelegations);
    }

    // Retrieve Active Delegations given an expiry date

    /**
     * @notice Returns an array of all active delegations on a certain date for a specific use case on a specific NFT collection
     *
     */
     function retrieveActiveToDelegations(address _profileAddress, address _collectionAddress, uint256 _date, uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationToCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateToHashes[hash].length-1; i++){
            if ((hash == delegateToHashes[hash][i].delegationToHash) && (delegateToHashes[hash][i].expiryDate > _date  )) {
                allDelegations[count] = delegateToHashes[hash][i].delegationAddress;
                count=count+1;
            }
        }
        return (allDelegations);
    }

    /**
     * @notice Returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection 
     *
    */

     function retrieveActiveFromDelegations(address _profileAddress, address _collectionAddress, uint256 _date, uint8 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationFromCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateFromHashes[hash].length-1; i++){
           if ((hash == delegateFromHashes[hash][i].delegationFromHash) && (delegateFromHashes[hash][i].expiryDate > _date  )) {
                allDelegations[count] = delegateFromHashes[hash][i].mainAddress;
                count=count+1;
            }
        }
        return (allDelegations);
    }

    // Retrieve Most Recent Delegations

    /**
     * @notice Returns the most recent delegations for a specific use case on a specific NFT collection
     */

    function retrieveMostRecentToDelegations(address _profileAddress, address _collectionAddress, uint8 _useCase) external view returns (address ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationToCounterPerHash[hash]);
        uint256[] memory allTimes = new uint256[](delegationToCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateToHashes[hash].length-1; i++){
            if ((hash == delegateToHashes[hash][i].delegationToHash) && (delegateToHashes[hash][i].expiryDate > 1  )) {
                allDelegations[count] = delegateToHashes[hash][i].delegationAddress;
                allTimes[count] = delegateToHashes[hash][i].registeredDate;
                count=count+1;
            }
        }
        uint256 mostrecent;
        mostrecent = allTimes[0];
        for (uint256 i=0; i<=allTimes.length-1; i++){
           if (allTimes[i] >= mostrecent) {
                mostrecent = i;
            }
        } 
        return allDelegations[mostrecent];
    }

    /**
     * @notice Returns the most recent delegators for a specific use case on a specific NFT collection 
    */

     function retrieveMostRecentFromDelegations(address _profileAddress, address _collectionAddress, uint8 _useCase) external view returns (address ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegationFromCounterPerHash[hash]);
        uint256[] memory allTimes = new uint256[](delegationFromCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateFromHashes[hash].length-1; i++){
           if ((hash == delegateFromHashes[hash][i].delegationFromHash) && (delegateFromHashes[hash][i].expiryDate > 1  )) {
                allDelegations[count] = delegateFromHashes[hash][i].mainAddress;
                allTimes[count] = delegateFromHashes[hash][i].registeredDate;
                count=count+1;
            }
        }
        uint256 mostrecent;
        mostrecent = allTimes[0];
        for (uint256 i=0; i<=allTimes.length-1; i++){
           if (allTimes[i] >= mostrecent) {
                mostrecent = i;
            }
        } 
        return allDelegations[mostrecent];
    }

    // Retrieve tokenids delegated

        /**
     * @notice Returns an array of all token ids delegated to an address for a specific usecase on specific collection
     * 
     */
     function retrieveTokenIDsToDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (int256[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        int256[] memory allTokens = new int256[](delegationToCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateToHashes[hash].length-1; i++){
            if (hash == delegateToHashes[hash][i].delegationToHash) {
                allTokens[count] = delegateToHashes[hash][i].tokens;
                count=count+1;
            }
        }
        return (allTokens);
    }

    /**
     * @notice Returns an array of all token ids delegated from an address for a specific usecase on specific collection
     *
     */
     function retrieveTokensIDsFromDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint8 _useCase) external view returns (int256[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
         int256[] memory allTokens = new int256[](delegationFromCounterPerHash[hash]);
        uint256 count;
        count=0;
        for (uint256 i=0; i<=delegateFromHashes[hash].length-1; i++){
            if (hash == delegateFromHashes[hash][i].delegationFromHash) {
                allTokens[count] = delegateFromHashes[hash][i].tokens;
                count=count+1;
            }
        }
        return (allTokens);
    }
}
