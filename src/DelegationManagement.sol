// SPDX-License-Identifier: MIT

/** 
 *
 *  @title: Delegation Management Contract   
 *  @date: 21-Dec-2022 @ 10:30
 *  @version: 4.23 
 *  @notes: This is a experimental contract for delegation registry
 *  @author: skynet2030 (skyn3t2030)
 *
 */

pragma solidity >=0.6.0 <=0.8.0;

contract delegationManagement {

    // Variable declarations
    uint256 useCaseCounter; 

    // Mapping declarations
    mapping (bytes32 => bool) public registeredDelegation;

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
        uint256 useCase;
    }

    // bytes32 mappings with arrays
    mapping (bytes32 => delegationAddresses[]) public delegateToHashes;
    mapping (bytes32 => delegationAddresses[]) public delegateFromHashes;

    // Events declaration

    event registerDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase);
    event revokeDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase);
    event updateDelegation(address indexed from, address indexed collectionAddress, address olddelegationAddress, address indexed newdelegationAddress, uint256 useCase);
    
    // Constructor
    constructor() public {
        useCaseCounter = 15;
    }
  
    /**
     * @notice Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
     * 
     */
    function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint256 _useCase) public {
        require((_useCase >0 && _useCase < useCaseCounter) || (_useCase == 99));
        bytes32 toHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        bytes32 fromHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        bytes32 globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
        
        require(registeredDelegation[globalHash] == false);

        delegationAddresses memory newdelegationAddress = delegationAddresses(msg.sender, globalHash, toHash, fromHash, _collectionAddress, _delegationAddress, block.timestamp, _expiryDate, _useCase);
        delegateToHashes[toHash].push(newdelegationAddress);
        delegateFromHashes[fromHash].push(newdelegationAddress);
		registeredDelegation[globalHash] = true;
        emit registerDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
    }

    /**
     * @notice Delegator revokes delegation rights from a delagation address given to a specific use case on a specific NFT collection
     * 
     */
    function revokeDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _useCase) public {
        bytes32 toHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
        bytes32 fromHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
        bytes32 globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));

        uint256 toHashLength = delegateToHashes[toHash].length;
        uint256 fromHashLength = delegateFromHashes[fromHash].length;

        if (toHashLength == 1) {
            delete delegateToHashes[toHash];
        } else {
            for (uint256 i = 0; i <= toHashLength; i++) {
                if (globalHash == delegateToHashes[toHash][i].delegationGlobalHash) {
                    delegateToHashes[toHash][i] = delegateToHashes[toHash][toHashLength-1];
                    delegateToHashes[toHash].pop();
                    break;
                }
            }
        }

        if (fromHashLength == 1) {
            delete delegateFromHashes[fromHash];
        } else {
            for (uint256 i = 0; i <= fromHashLength; i++) {
                if (globalHash == delegateFromHashes[fromHash][i].delegationGlobalHash) {
                    delegateFromHashes[fromHash][i] = delegateFromHashes[fromHash][fromHashLength-1];
                    delegateFromHashes[fromHash].pop();
                    break;
                }
            }
        }

        registeredDelegation[globalHash] =false;
        emit revokeDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
    }

    /**
     * @notice Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
     * 
     */
    function updateDelegationAddress (address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint256 _useCase) public {
        registerDelegationAddress(_collectionAddress, _newdelegationAddress, _expiryDate, _useCase);
        revokeDelegationAddress(_collectionAddress, _olddelegationAddress, _useCase);
        emit updateDelegation(msg.sender, _collectionAddress, _olddelegationAddress, _newdelegationAddress, _useCase);
    }

    // Getter functions

    function toHashCounter(bytes32 toHash) public view returns (uint256) {
        return delegateToHashes[toHash].length;
    }

    function fromHashCounter(bytes32 fromHash) public view returns (uint256) {
        return delegateFromHashes[fromHash].length;
    }

    /**
     * @notice Support function used to retrieve the hash given specific parameters
     * 
     */
    function retrieveHash(address _profileAddress, address _collectionAddress, uint256 _useCase) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_profileAddress,_collectionAddress,_useCase));
    }
    
    /**
     * @notice Returns an array of all delegation addresses (active AND inactive) set by a delegator for a specific use case on a specific NFT collection
     * 
     */
     function retrieveToDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint256 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegateToHashes[hash].length);
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
     function retrieveFromDelegationAddressesPerUsecaseForCollection(address _profileAddress, address _collectionAddress,uint256 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegateFromHashes[hash].length);
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

    // Retrieve Active Delegations

    /**
     * @notice Returns an array of all active delegations on a certain date for a specific use case on a specific NFT collection
     *
     */
     function retrieveActiveToDelegations(address _profileAddress, address _collectionAddress, uint256 _date, uint256 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegateToHashes[hash].length);
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

     function retrieveActiveFromDelegations(address _profileAddress, address _collectionAddress, uint256 _date, uint256 _useCase) external view returns (address[] memory ) {
        bytes32 hash;
        hash = keccak256(abi.encodePacked(_profileAddress, _collectionAddress, _useCase));
        address[] memory allDelegations = new address[](delegateFromHashes[hash].length);
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
}
