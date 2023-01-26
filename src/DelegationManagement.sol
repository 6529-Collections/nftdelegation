// SPDX-License-Identifier: MIT

/** 
 *
 *  @title: Delegation Management Contract
 *  @date: 26-Jan-2022 @ 22:50
 *  @version: 5.20.7
 *  @notes: This is an experimental contract for delegation registry
 *  @author: skynet2030 (skyn3t2030)
 *  @credits: to be added ...
 *  @modifications: removed locks from registration, created new subdelegation functions for registering and revoking, added a retrieve subdelegation status function, optimized most recent functions
 *
 */

pragma solidity ^0.8.17;

contract delegationManagementContract {

    // Variable declarations
    uint256 useCaseCounter;

    // Mapping declarations
    mapping (bytes32 => address[]) public delegatorHashes;
    mapping (bytes32 => address[]) public delegationAddressHashes;

    struct globalData {
        uint256 registeredDate;
        uint256 expiryDate;
        bool allTokens;
        uint256 tokens;
    }

    // Mapping of globalData struct declaration
    mapping (bytes32 => globalData[]) public globalDelegationHashes;

    // Events declaration
    event registerDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase, bool allTokens, uint256 _tokenid);
    event registerDelegationUsingSubDelegation(address indexed delegator, address from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase, bool allTokens, uint256 _tokenid);
    event revokeDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase);
    event revokeDelegationUsingSubDelegation(address indexed delegator, address from, address indexed collectionAddress, address indexed delegationAddress, uint8 useCase);
    event updateDelegation(address indexed from, address indexed collectionAddress, address olddelegationAddress, address indexed newdelegationAddress, uint8 useCase, bool allTokens, uint256 _tokenid);
    
    // Global Registry for all collections & usecases history
    mapping (address => address[]) public CollectionsRegistered;
    mapping (address => uint256[]) public UseCaseRegistered;

    // Locks declarations
    mapping (address => bool) public globalLock;
    mapping (bytes32 => bool) public collectionLock;
    mapping (bytes32 => bool) public collectionUsecaseLock;

    //Errors
    error UseCaseOutOfBounds();
    error delegationAddressGlobalLockExists();
    error delegationAddressCollectionLockExists();
    error delegationAddressCollectionUsecaseLockExists();

    // Constructor
    constructor() {
        useCaseCounter = 17;
    }
  
    /**
     * @notice Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
     * @notice _collectionAddress --> 0x8888888888888888888888888888888888888888 = All collections
     * @notice For all Tokens-- > _allTokens needs to be true, _tokenId does not matter
     */

    function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint8 _useCase, bool _allTokens, uint256 _tokenid) public {
        if ((_useCase < 0) || (_useCase > useCaseCounter && _useCase != 99)) revert UseCaseOutOfBounds();

        bytes32 delegatorHash;
        bytes32 delegationAddressHash;
        bytes32 globalHash;
        bytes32 collectionLockHash;
        bytes32 collectionUsecaseLockHash;
        // Locks
        collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
        collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
        if(globalLock[_delegationAddress]) revert delegationAddressGlobalLockExists();
        if(collectionLock[collectionLockHash]) revert delegationAddressCollectionLockExists();
        if(collectionUsecaseLock[collectionUsecaseLockHash]) revert delegationAddressCollectionUsecaseLockExists();
        // Push data to mappings
        globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        delegatorHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        // Stores delegation addresses on a delegator hash
        delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        delegatorHashes[delegatorHash].push(_delegationAddress);
        // Stores delegators addresses on a delegation address hash
        delegationAddressHashes[delegationAddressHash].push(msg.sender);
        // Store Delegation history
        CollectionsRegistered[msg.sender].push(_collectionAddress);
        UseCaseRegistered[msg.sender].push(_useCase);
        // Push additional data to the globalDelegationHashes mapping
        if (_allTokens == true) {
            globalData memory newdelegationGlobalData = globalData(block.timestamp, _expiryDate, true, 0);
            globalDelegationHashes[globalHash].push(newdelegationGlobalData);
        } else {
            globalData memory newdelegationGlobalData = globalData(block.timestamp, _expiryDate, false, _tokenid);
            globalDelegationHashes[globalHash].push(newdelegationGlobalData);
        }
        emit registerDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase, _allTokens, _tokenid);
    }

     /**
     * @notice Function to support subDelegation rights
     * @notice A delegation Address that has subDelegation rights given by a Delegator can register Delegations on behalf of Delegator
     */

    function registerDelegationAddressUsingSubDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint8 _useCase, bool _allTokens, uint256 _tokenid) public {
        // Check subdelegation rights for the specific collection
        {bool subdelegationRightsCol;
        address[] memory allDelegators = retrieveDelegators(msg.sender, _collectionAddress, 16);
        if (allDelegators.length > 0) {
        for (uint i=0; i<allDelegators.length; i++) {
            if (_delegatorAddress == allDelegators[i]) {
                subdelegationRightsCol = true;
                break;
            }
        }
        }
        // Check subdelegation rights for All collections
        bool subdelegationRightsAll;
        allDelegators = retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 16);
        if (allDelegators.length > 0) {
            if (subdelegationRightsCol != true) {
                for (uint i=0; i<allDelegators.length; i++) {
                    if (_delegatorAddress == allDelegators[i]) {
                    subdelegationRightsCol = true;
                    break;
                    }
                }
            }
        }
        // Allow to register
        require ((subdelegationRightsCol == true) || (subdelegationRightsAll == true));
        }
        // If check passed then register delegation address for Delegator
        require((_useCase >0 && _useCase < useCaseCounter) || (_useCase == 99));
        bytes32 delegatorHash;
        bytes32 delegationAddressHash;
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
        globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
        delegatorHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
        // Stores delegation addresses on a delegator hash
        delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        delegatorHashes[delegatorHash].push(_delegationAddress);
        // Stores delegators addresses on a delegation address hash
        delegationAddressHashes[delegationAddressHash].push(_delegatorAddress);
        // Store Delegation history
        CollectionsRegistered[_delegatorAddress].push(_collectionAddress);
        UseCaseRegistered[_delegatorAddress].push(_useCase);
        // Push additional data to the globalDelegationHashes mapping
        if (_allTokens == true) {
            globalData memory newdelegationGlobalData = globalData(block.timestamp, _expiryDate, true, 0);
            globalDelegationHashes[globalHash].push(newdelegationGlobalData);
        } else {
            globalData memory newdelegationGlobalData = globalData(block.timestamp, _expiryDate, false, _tokenid);
            globalDelegationHashes[globalHash].push(newdelegationGlobalData);
        }
        emit registerDelegationUsingSubDelegation(_delegatorAddress, msg.sender, _collectionAddress, _delegationAddress, _useCase, _allTokens, _tokenid);
    }

    /**
     * @notice Delegator revokes delegation rights given to a delegation address on a specific use case on a specific NFT collection
     * @notice This function does not remove the delegation from the CollectionsRegistered or UseCaseRegistered as we want to track delegations history
     */
    
    function revokeDelegationAddress(address _collectionAddress, address _delegationAddress, uint8 _useCase) public {
        bytes32 delegatorHash;
        bytes32 delegationAddressHash;
        bytes32 globalHash;
        uint256 count;
        globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        delegatorHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        // Revoke delegation Address from the delegatorHashes mapping
        count=0;
        if (delegatorHashes[delegatorHash].length>0) {
            for (uint256 i=0; i<=delegatorHashes[delegatorHash].length-1; i++){
                if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
                    count=count+1;
                }
            }
            uint256[] memory delegationsPerUser = new uint256[](count);
            uint256 count1=0;
            for (uint256 i=0; i<=delegatorHashes[delegatorHash].length-1; i++){
                if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
                    delegationsPerUser[count1] = i;
                    count1=count1+1;
                }
            }
            if (count1>0) {
            for (uint256 j=0; j<=delegationsPerUser.length-1; j++) {
                uint256 temp1;
                uint256 temp2;
                temp1 = delegationsPerUser[delegationsPerUser.length-1-j];
                temp2 = delegatorHashes[delegatorHash].length-1;
                delegatorHashes[delegatorHash][temp1] = delegatorHashes[delegatorHash][temp2];
                delegatorHashes[delegatorHash].pop();
            }
            }
        // Revoke delegator Address from the delegationAddressHashes mapping
            uint256 countDA=0;
            for (uint256 i=0; i<=delegationAddressHashes[delegationAddressHash].length-1; i++){
                if (msg.sender == delegationAddressHashes[delegationAddressHash][i]) {
                    countDA=countDA+1;
                }
            }
            uint256[] memory delegatorsPerUser = new uint256[](countDA);
            uint256 countDA1=0;
            for (uint256 i=0; i<=delegationAddressHashes[delegationAddressHash].length-1; i++){
                if (msg.sender == delegationAddressHashes[delegationAddressHash][i]) {
                    delegatorsPerUser[countDA1] = i;
                    countDA1=countDA1+1;
                }
            }
            if (countDA1>0) {
                for (uint256 j=0; j<=delegatorsPerUser.length-1; j++) {
                    uint256 temp1;
                    uint256 temp2;
                    temp1 = delegatorsPerUser[delegatorsPerUser.length-1-j];
                    temp2 = delegationAddressHashes[delegationAddressHash].length-1;
                    delegationAddressHashes[delegationAddressHash][temp1] = delegationAddressHashes[delegationAddressHash][temp2];
                    delegationAddressHashes[delegationAddressHash].pop();
                }
            }
        // Reset Locks and other restrictions
            bytes32 collectionLockHash;
            bytes32 collectionUsecaseLockHash;
            collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
            collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
            collectionLock[collectionLockHash] = false;
            collectionUsecaseLock[collectionUsecaseLockHash] = false;
            globalLock[_delegationAddress] = false;
            delete globalDelegationHashes[globalHash];
            emit revokeDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
        }
    }

    /**
     * @notice This function supports the revoking of a Delegation Address using an address with Subdelegation rights
     */
    
    function revokeDelegationAddressUsingSubdelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint8 _useCase) public {
        // Check subdelegation rights for the specific collection
        {bool subdelegationRightsCol;
        address[] memory allDelegators = retrieveDelegators(msg.sender, _collectionAddress, 16);
        if (allDelegators.length > 0) {
        for (uint i=0; i<allDelegators.length; i++) {
            if (_delegatorAddress == allDelegators[i]) {
                subdelegationRightsCol = true;
                break;
            }
        }
        }
        // Check subdelegation rights for All collections
        bool subdelegationRightsAll;
        allDelegators = retrieveDelegators(msg.sender, 0x8888888888888888888888888888888888888888, 16);
        if (allDelegators.length > 0) {
            if (subdelegationRightsCol != true) {
                for (uint i=0; i<allDelegators.length; i++) {
                    if (_delegatorAddress == allDelegators[i]) {
                    subdelegationRightsCol = true;
                    break;
                    }
                }
            }
        }
        // Allow to revoke
        require ((subdelegationRightsCol == true) || (subdelegationRightsAll == true));
        }
        // If check passed then revoke delegation address for Delegator
        bytes32 delegatorHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
        bytes32 delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        bytes32 globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase)); 
        uint256 count;
        count=0;
        if (delegatorHashes[delegatorHash].length>0) {
            for (uint256 i=0; i<=delegatorHashes[delegatorHash].length-1; i++){
                if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
                    count=count+1;
                }
            }
            uint256[] memory delegationsPerUser = new uint256[](count);
            uint256 count1=0;
            for (uint256 i=0; i<=delegatorHashes[delegatorHash].length-1; i++){
                if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
                    delegationsPerUser[count1] = i;
                    count1=count1+1;
                }
            }
            if (count1>0) {
                for (uint256 j=0; j<=delegationsPerUser.length-1; j++) {
                    uint256 temp1;
                    uint256 temp2;
                    temp1 = delegationsPerUser[delegationsPerUser.length-1-j];
                    temp2 = delegatorHashes[delegatorHash].length-1;
                    delegatorHashes[delegatorHash][temp1] = delegatorHashes[delegatorHash][temp2];
                    delegatorHashes[delegatorHash].pop();
                }
            }
        // Revoke delegator Address from the delegationAddressHashes mapping
            uint256 countDA=0;
            for (uint256 i=0; i<=delegationAddressHashes[delegationAddressHash].length-1; i++){
                if (_delegatorAddress == delegationAddressHashes[delegationAddressHash][i]) {
                    countDA=countDA+1;
                }
            }
            uint256[] memory delegatorsPerUser = new uint256[](countDA);
            uint256 countDA1=0;
            for (uint256 i=0; i<=delegationAddressHashes[delegationAddressHash].length-1; i++){
                if (_delegatorAddress == delegationAddressHashes[delegationAddressHash][i]) {
                    delegatorsPerUser[countDA1] = i;
                    countDA1=countDA1+1;
                }
            }
            if (countDA1>0) {
            for (uint256 j=0; j<=delegatorsPerUser.length-1; j++) {
                uint256 temp1;
                uint256 temp2;
                temp1 = delegatorsPerUser[delegatorsPerUser.length-1-j];
                temp2 = delegationAddressHashes[delegationAddressHash].length-1;
                delegationAddressHashes[delegationAddressHash][temp1] = delegationAddressHashes[delegationAddressHash][temp2];
                delegationAddressHashes[delegationAddressHash].pop();
            }
            }
            // Reset Locks and other restrictions
            {
            bytes32 collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
            bytes32 collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase)); 
            collectionLock[collectionLockHash] = false;
            collectionUsecaseLock[collectionUsecaseLockHash] = false;
            globalLock[_delegationAddress] = false;
            delete globalDelegationHashes[globalHash];
            }
            {
            emit revokeDelegationUsingSubDelegation(_delegatorAddress, msg.sender, _collectionAddress, _delegationAddress, _useCase);
            }
        }
    }

    /**
     * @notice This function revokes all delegations registered by a Delegator
     */

    function revokeAll() public {
        address[] memory allCollections = CollectionsRegistered[msg.sender];
        uint256[] memory allUseCases = UseCaseRegistered[msg.sender];
        address[] memory delegationAddresses;
        for (uint256 i=0; i<= allCollections.length-1; i++) {
            delegationAddresses = retrieveDelegationAddresses(msg.sender, allCollections[i], uint8(allUseCases[i]));
            if (delegationAddresses.length>0) {
                for (uint y=0; y<=delegationAddresses.length-1; y++) {
                revokeDelegationAddress(allCollections[i], delegationAddresses[y], uint8(allUseCases[i]));
                }
            }
        }
    // Reset History of a Delegator
        for (uint256 x=0; x<=allCollections.length-1; x++) {
                CollectionsRegistered[msg.sender].pop();
                UseCaseRegistered[msg.sender].pop();
        }
    }

    /**
     * @notice Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
     */

    function updateDelegationAddress (address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint8 _useCase, bool _allTokens, uint256 _tokenid) public {
        revokeDelegationAddress(_collectionAddress, _olddelegationAddress, _useCase);
        registerDelegationAddress(_collectionAddress, _newdelegationAddress, _expiryDate, _useCase, _allTokens, _tokenid);
        emit updateDelegation(msg.sender, _collectionAddress, _olddelegationAddress, _newdelegationAddress, _useCase, _allTokens, _tokenid);
    }

    /**
     * @notice Batch Registrations function
     */

    function batchDelegations (address[] memory _collectionAddress, address[] memory _newdelegationAddress, uint256[] memory _expiryDate, uint8[] memory _useCase, bool[] memory _allTokens, uint256[] memory _tokenid) public {
        for (uint256 i=0; i<=_collectionAddress.length-1; i++) {
        registerDelegationAddress(_collectionAddress[i], _newdelegationAddress[i], _expiryDate[i], _useCase[i], _allTokens[i], _tokenid[i]);
        }
    }

    /**
     * @notice Set global Lock status (hot wallet)
     */

     function setglobalLock(bool _status) public {
         globalLock[msg.sender] = _status;
     }

     /**
     * @notice Set collection Lock status (hot wallet)
     */

     function setcollectionLock(address _collectionAddress, bool _status) public {
         bytes32 collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender));
         collectionLock[collectionLockHash] = _status;
     }

     /**
     * @notice Set collection usecase Lock status (hot wallet)
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
     * @notice Support function to retrieve the hash given specific parameters
     */

    function retrieveLocalHash(address _walletAddress, address _collectionAddress, uint8 _useCase) public pure returns (bytes32) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_walletAddress, _collectionAddress, _useCase));
        return (hash);
    }

    /**
     * @notice Support function to retrieve the global hash given specific parameters
     */

    function retrieveGlobalHash(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint8 _useCase) public pure returns (bytes32) {
        bytes32 globalHash;
        globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
        return (globalHash);
    }
    
    /**
     * @notice Returns an array of all delegation addresses (active AND inactive) assigned by a delegator for a specific use case on a specific NFT collection
     */

     function retrieveDelegationAddresses(address _delegatorAddress, address _collectionAddress,uint8 _useCase) public view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
        return (delegatorHashes[hash]);
    }

    /**
     * @notice Returns an array of all delegators (active AND inactive) that delegated to a delegationAddress for a specific use case on a specific NFT collection
     */

     function retrieveDelegators(address _delegationAddress, address _collectionAddress,uint8 _useCase) public view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        return (delegationAddressHashes[hash]);
    }

    /**
     * @notice Returns the collection and usecase history given a delegator address
     */

     function retrieveHistory(address _delegatorAddress) public view returns (address[] memory, uint256[] memory ) {
        return (CollectionsRegistered[_delegatorAddress], UseCaseRegistered[_delegatorAddress]);
    }

    /**
     * @notice Returns the status of a collection/delegation for a delegator (cold wallet)
     * @notice false means that the cold wallet did not register a delegation or the delegation was revoked from the delegatorHashes mapping
     */

     function retrieveDelegatorStatusOfDelegation(address _delegatorAddress, address _collectionAddress,uint8 _useCase) public view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
        if (delegatorHashes[hash].length >0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @notice Returns the status of a collection/delegation given a delegation address (hot wallet)
     * @notice false means that a delegation address is not registered or it was revoked from the delegationAddressHashes mapping
     */

     function retrieveDelegationAddressStatusOfDelegation(address _delegationAddress, address _collectionAddress,uint8 _useCase) public view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        if (delegationAddressHashes[hash].length >0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @notice Returns the status of a delegation given the delegator address as well as the delegation address
     */

     function retrieveGlobalStatusOfDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint8 _useCase) public view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
        if (globalDelegationHashes[hash].length >0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @notice Returns the status of a delegation given the delegator address, the collection address, the delegation address as well as a specific token id
    */

     function retrieveTokenStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint8 _useCase, uint256 _tokenid) public view returns (bool) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
        bool status;
        if (globalDelegationHashes[hash].length > 0) {
            for (uint256 i=0; i<= globalDelegationHashes[hash].length-1; i++) {
                if ((globalDelegationHashes[hash][i].allTokens == false) && (globalDelegationHashes[hash][i].tokens == _tokenid)) {
                    status = true;
                    break;
                } else {
                    status = false;
                }
            }
            return status; 
        } else {
            return false;
        }
     }

    /**
     * @notice Checks if the delegation address performing actions is the most recent delegated by the specific delegator
    */

     function retrieveStatusOfMostRecentDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint8 _useCase) public view returns (bool) {
     if (_delegationAddress == retrieveMostRecentDelegation(_delegatorAddress, _collectionAddress, _useCase)){
         return true;
     } else {
         return false;
     }
     }

     /**
     * @notice Checks if a delegator granted subdelegation status to an Address
    */

    function retrieveSubDelegationStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress) public view returns(bool) {
        bool subdelegationRights;
        address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, 16);
        if (allDelegators.length > 0) {
            for (uint i=0; i<=allDelegators.length; i++) {
                if (_delegatorAddress == allDelegators[i]) {
                    subdelegationRights = true;
                    break;
                }
            }
        }
        if (subdelegationRights == true) {
            return (true);
        } else {
            return (false);
        }
    }

     /**
     * @notice Checks the status of an active delegator for a delegation Address
    */

     function retrieveStatusOfActiveDelegator(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _date, uint8 _useCase) public view returns (bool) {
     address[] memory allActiveDelegators = retrieveActiveDelegators(_delegationAddress, _collectionAddress, _date, _useCase);
     bool status;
     if (allActiveDelegators.length>0) {
        for (uint256 i=0; i<= allActiveDelegators.length-1; i++) {
            if (_delegatorAddress == allActiveDelegators[i]) {
                status = true;
                break;
            } else {
                status = false;
            }
        }
        return status; 
        } else {
        return false;
        } 
     } 

    // Retrieve Delegations delegated by a Delegator
    // This set of functions is used to retrieve info for a Delegator (cold address)

    function retrieveDelegationAddressesTokensIDsandExpiredDates(address _delegatorAddress, address _collectionAddress,uint8 _useCase) public view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory) {
        address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
        uint256 count1 =0 ;
        uint256 count2 =0 ;
        uint256 k=0;
        if (allDelegations.length>0) {
            for (uint256 i=0; i<=allDelegations.length-1; i++){
                globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
            //Removes duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory tokensIDs = new uint256[](k);
            bool[] memory allTokens = new bool[](k);
            uint256[] memory allExpirations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
                    allTokens[count2] = globalDelegationHashes[allGlobalHashes[y]][w].allTokens;
                    tokensIDs[count2] = globalDelegationHashes[allGlobalHashes[y]][w].tokens;
                    count2 = count2 + 1;
                    }
                }
            }
            return (allDelegations, allExpirations, allTokens, tokensIDs);
        } else {
            address[] memory allDelegations1 = new address[](0);
            uint256[] memory tokensIDs = new uint256[](0);
            bool[] memory allTokens = new bool[](0);
            uint256[] memory allExpirations = new uint256[](0);
            return (allDelegations1, allExpirations, allTokens, tokensIDs);
        }
    }

    /**
     * @notice Returns an array of all active delegation addresses on a certain date for a specific use case on a specific NFT collection given a delegation Address
    */
        
    function retrieveActiveDelegations(address _delegatorAddress, address _collectionAddress, uint256 _date, uint8 _useCase) public view returns (address[] memory) {
        address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
        uint256 count1 =0;
        uint256 count2 =0;
        uint256 count3 =0;
        uint256 k=0;
        if (allDelegations.length>0) {
            for (uint256 i=0; i<=allDelegations.length-1; i++){
                globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
        //Remove duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                    k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory allExpirations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
                    count2 = count2 + 1;
                    }
                }
            }
            address[] memory allActive = new address[](allExpirations.length);
            for (uint256 y=0; y<=k-1; y++){
                if (allExpirations[y]>_date) {
                    allActive[count3] = allDelegations[y];
                    count3 = count3 + 1;
                }
            }
            return (allActive); 
        } else {
            address[] memory allActive = new address[](0);
            return (allActive);
        }
    }

    /**
     * @notice Returns the most recent delegation address delegated for a specific use case on a specific NFT collection 
    */

    function retrieveMostRecentDelegation(address _delegatorAddress, address _collectionAddress, uint8 _useCase) public view returns (address) {
        address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
        uint256 count1 =0 ;
        uint256 count2 =0 ;
        uint256 k=0;
        if (allDelegations.length>0) {
            for (uint256 i=0; i<=allDelegations.length-1; i++){
                globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
            //Removes duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory allRegistrations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allRegistrations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].registeredDate;
                    count2 = count2 + 1;
                    }
                }
            }
            address recentDelegationAddress = allDelegations[0];
            uint256 time = allRegistrations[0];
            for (uint256 i=0; i<=allDelegations.length-1; i++){
                if (allRegistrations[i] > time){
                    time = allRegistrations[i];
                    recentDelegationAddress = allDelegations[i];
                }
            }
            return (recentDelegationAddress);
        } else {
        return (0x0000000000000000000000000000000000000000);
    }
    }


    // Retrieve Delegators delegated to a hot wallet 
    // This set of functions is used to retrieve info for a hot wallet

    /**
     * @notice Returns an array of all token ids delegated by a Delegator for a specific usecase on specific collection given a delegation Address
     */
     function retrieveDelegatorsTokensIDsandExpiredDates(address _delegationAddress, address _collectionAddress,uint8 _useCase) public view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory) {
        address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
        uint256 count1 =0 ;
        uint256 count2 =0 ;
        uint256 k=0;
        if (allDelegators.length>0) {
            for (uint256 i=0; i<=allDelegators.length-1; i++){
                globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
        //Removes duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory tokensIDs = new uint256[](k);
            bool[] memory allTokens = new bool[](k);
            uint256[] memory allExpirations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
                    allTokens[count2] = globalDelegationHashes[allGlobalHashes[y]][w].allTokens;
                    tokensIDs[count2] = globalDelegationHashes[allGlobalHashes[y]][w].tokens;
                    count2 = count2 + 1;
                    }
                }
            }
            return (allDelegators, allExpirations, allTokens, tokensIDs);
        } else {
            address[] memory allDelegations1 = new address[](0);
            uint256[] memory tokensIDs = new uint256[](0);
            bool[] memory allTokens = new bool[](0);
            uint256[] memory allExpirations = new uint256[](0);
            return (allDelegations1, allExpirations, allTokens, tokensIDs);

        }
     }

    /**
     * @notice Returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection given a delegation Address
    */

     function retrieveActiveDelegators(address _delegationAddress, address _collectionAddress, uint256 _date, uint8 _useCase) public view returns (address[] memory) {
        address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
        uint256 count1 =0;
        uint256 count2 =0;
        uint256 count3 =0;
        uint256 k=0;
        if (allDelegators.length>0) {
            for (uint256 i=0; i<=allDelegators.length-1; i++){
                globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
        //Remove duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                    k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory allExpirations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
                    count2 = count2 + 1;
                    }
                }
            }
            address[] memory allActive = new address[](allExpirations.length);
            for (uint256 y=0; y<=k-1; y++){
                if (allExpirations[y]>_date) {
                    allActive[count3] = allDelegators[y];
                    count3 = count3 + 1;
                }
            }
            return (allActive); 
        } else {
            address[] memory allActive = new address[](0);
            return (allActive);
        }
     }

    /**
     * @notice Returns the most recent delegator for a specific use case on a specific NFT collection given a delegation Address
    */

     function retrieveMostRecentDelegator(address _delegationAddress, address _collectionAddress, uint8 _useCase) public view returns (address) {
         address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
        bytes32 globalHash;
        bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
        uint256 count1 =0 ;
        uint256 count2 =0 ;
        uint256 k=0;
        if (allDelegators.length>0) {
            for (uint256 i=0; i<=allDelegators.length-1; i++){
                globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
                allGlobalHashes[count1] = globalHash;
                count1 = count1+1;
            }
        //Removes duplicates
            for (uint256 i = 0; i < allGlobalHashes.length - 1; i++) {
                for (uint256 j = i + 1; j < allGlobalHashes.length; j++) {
                    if (allGlobalHashes[i] == allGlobalHashes[j]) {
                    delete allGlobalHashes[i];
                    }
                }
            }
            for (uint256 i=0; i<=allGlobalHashes.length-1; i++){
                k = globalDelegationHashes[allGlobalHashes[i]].length + k;
            }
        //Declare local arrays
            uint256[] memory allRegistrations = new uint256[](k);
            for (uint256 y=0; y<=k-1; y++){
                if (globalDelegationHashes[allGlobalHashes[y]].length>0) {
                    for (uint256 w=0; w<=globalDelegationHashes[allGlobalHashes[y]].length-1; w++){
                    allRegistrations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].registeredDate;
                    count2 = count2 + 1;
                    }
                }
            }
            address recentDelegatorAddress = allDelegators[0];
            uint256 time = allRegistrations[0];
            for (uint256 i=0; i<=allDelegators.length-1; i++){
                if (allRegistrations[i] > time){
                    time = allRegistrations[i];
                    recentDelegatorAddress = allDelegators[i];
                }
            }
            return (recentDelegatorAddress);
        } else {
        return (0x0000000000000000000000000000000000000000);
    }
     }

    /**
     * @notice This function checks the Consolidation status between 2 addresses
    */

    function checkConsolidation(address _wallet1, address _wallet2, address _collectionAddress) public view returns( bool ) {
        address[] memory allDelegationsWallet1 = retrieveDelegationAddresses(_wallet1, _collectionAddress, 99);
        address[] memory allDelegationsWallet2 = retrieveDelegationAddresses(_wallet2, _collectionAddress, 99);
        bool wallet1Consolidation;
        bool wallet2Consolidation;
        if (allDelegationsWallet1.length>0 && allDelegationsWallet2.length>0) {
            for (uint256 i=0; i<=allDelegationsWallet1.length-1; i++) {
                if (_wallet2 == allDelegationsWallet1[i]) {
                    wallet1Consolidation = true;
                }
            }
            for (uint256 i=0; i<=allDelegationsWallet2.length-1; i++) {
                if (_wallet1 == allDelegationsWallet2[i]) {
                    wallet2Consolidation = true;
                }
            }
        }
        if (wallet1Consolidation == true && wallet2Consolidation == true) {
            return true;
        } else {
            return false;
        }
    }
     
}
