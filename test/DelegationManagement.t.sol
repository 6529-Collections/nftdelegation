// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

import {delegationManagement} from "../src/DelegationManagement.sol";

contract ContractTest is Test {
    delegationManagement delegation;

    function setUp() public {
        delegation = new delegationManagement();
    }

    function testRegisterAfterExpired() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        uint256 usecase = 14;
        uint256 ts = 1;

        bytes32 toHash = keccak256(abi.encodePacked(address(this), collection, usecase));
        uint256 toLength = delegation.toHashCounter(toHash);

        assertEq(toLength, 0);

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        toLength = delegation.toHashCounter(toHash);
        assertEq(toLength, 1);

        vm.warp(10);

        vm.expectRevert(); // current implementation fails here
        delegation.registerDelegationAddress(collection, delegationAddr, 12, usecase);
    }

    function testRevokeSingle() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        uint256 usecase = 14;
        uint256 ts = 1;

        bytes32 toHash = keccak256(abi.encodePacked(address(this), collection, usecase));
        uint256 beforeLength = delegation.toHashCounter(toHash);

        assertEq(beforeLength, 0);

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        uint256 afterLength = delegation.toHashCounter(toHash);
        assertEq(afterLength, 1);
        
        delegation.revokeDelegationAddress(collection, delegationAddr, usecase);

        uint256 afterDelLength = delegation.toHashCounter(toHash);
        assertEq(afterDelLength, 0);
    }

    function testRevokeMultiple() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        address collection2 = 0xbeEfEeb84610509DFE31B420c8D062Ab00153d23;

        address delegationAddr2 = 0xC0FFEeb84610509dFe31B420c8d062aB00153D23;

        uint256 usecase = 14;
        uint256 ts = 1;

        bytes32 toHash = keccak256(abi.encodePacked(address(this), collection, usecase));
        bytes32 toHash2 = keccak256(abi.encodePacked(address(this), collection2, usecase));
        uint256 toHashLength = delegation.toHashCounter(toHash);
        uint256 toHashLength2 = delegation.toHashCounter(toHash2);

        assertEq(toHashLength, 0);
        assertEq(toHashLength2, 0);

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        toHashLength = delegation.toHashCounter(toHash);
        toHashLength2 = delegation.toHashCounter(toHash2);
        assertEq(toHashLength, 1);
        assertEq(toHashLength2, 0);

        delegation.registerDelegationAddress(collection2, delegationAddr2, ts, usecase);

        toHashLength = delegation.toHashCounter(toHash);
        toHashLength2 = delegation.toHashCounter(toHash2);
        assertEq(toHashLength, 1);
        assertEq(toHashLength2, 1);

        delegation.revokeDelegationAddress(collection, delegationAddr, usecase);

        toHashLength = delegation.toHashCounter(toHash);
        toHashLength2 = delegation.toHashCounter(toHash2);
        assertEq(toHashLength, 0);
        assertEq(toHashLength2, 1);
    }

    function testRetrieveToDelegationAddresses() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        uint256 usecase = 14;
        uint256 ts = 1;

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        address[] memory result = delegation.retrieveToDelegationAddressesPerUsecaseForCollection(address(this), collection, usecase);

        assertEq(result.length, 1);
        assertEq(result[0], delegationAddr);
    }

    function testRetrieveFromDelegationAddresses() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        uint256 usecase = 14;
        uint256 ts = 1;

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        address[] memory result = delegation.retrieveFromDelegationAddressesPerUsecaseForCollection(delegationAddr, collection, usecase);

        assertEq(result.length, 1);
        assertEq(result[0], address(this));
    }

    function testRetieveActiveTo() public {
        address collection = 0xBEeFeEb84610509DFE31B420c8D062ab00153D24;
        address delegationAddr = 0xc0ffeeB84610509DFE31B420c8d062AB00153D24;

        uint256 usecase = 14;
        uint256 ts = 3;

        delegation.registerDelegationAddress(collection, delegationAddr, ts, usecase);

        address[] memory result = delegation.retrieveActiveToDelegations(address(this), collection, 1, usecase);

        assertEq(result.length, 1);
        assertEq(result[0], delegationAddr);

        vm.warp(2);

        address[] memory result2 = delegation.retrieveActiveToDelegations(address(this), collection, 5, usecase);

        // this fails
        assertEq(result2.length, 0);        
    }
}
