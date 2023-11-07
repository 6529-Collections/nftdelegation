const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers")
const { expect } = require("chai")
const { ethers } = require("hardhat")
const fixturesDeployment = require("../scripts/fixturesDeployment.js")

let signers
let contracts

describe("NFTDelegation tests", function () {
  before(async function () {
    ;({ signers, contracts } = await loadFixture(fixturesDeployment))
  })

  context("Verify Fixture", () => {
    it("Contracts are deployed", async function () {
      expect(await contracts.hhDelegation.getAddress()).to.not.equal(
        ethers.ZeroAddress,
      )
    })
  })

  context("Register Delegation", () => {
    
    // register a delegation using the owner address
    it("#registerDelegation", async function () {
      await contracts.hhDelegation.registerDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "1799339953",
        "1",
        "true",
        "0",
      )
    })

    // check the status of the delegation
    it("#checkDelegationStatus", async function () {
      const status = await contracts.hhDelegation.retrieveGlobalStatusOfDelegation(
        signers.owner.address,
        "0x8888888888888888888888888888888888888888",
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "1",
      )
      expect(status).equal(true); 
    })
    
  }) // end of register context

  context("Revoke Delegation", () => {

    // revoke the delegation registered on the previous context
    it("#revokeDelegation", async function () {
      await contracts.hhDelegation.revokeDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "1",
      )
    })

    // check the status of the delegation
    it("#checkDelegationStatus", async function () {
      const status = await contracts.hhDelegation.retrieveGlobalStatusOfDelegation(
        signers.owner.address,
        "0x8888888888888888888888888888888888888888",
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "1",
      )
      expect(status).equal(false); 
    })
    
  }) // end of revoke context

  context("Register Multiple Delegations", () => {

    // step1: register a delegation using the onwer address
    it("#registerDelegation1", async function () {
      await contracts.hhDelegation.registerDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "1799339953",
        "1",
        "true",
        "0",
      )
    })

    // step2: register a second delegation using the owner address
    it("#registerDelegation2", async function () {
      await contracts.hhDelegation.registerDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
        "1799339953",
        "1",
        "true",
        "0",
      )
    })

    // retrieve delegation addresses and check if the delegation address registered on step 1 exists
    it("#retrieveDelegationAddresses", async function () {
      const delegationAddresses = await contracts.hhDelegation.retrieveDelegationAddresses(
        signers.owner.address,
        "0x8888888888888888888888888888888888888888",
        "1",
      )
      expect(delegationAddresses[0]).equal("0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7"); 
    })

    // retrieve delegation addresses and check if the delegation address registered on step 2 exists
    it("#retrieveDelegationAddresses", async function () {
      const delegationAddresses = await contracts.hhDelegation.retrieveDelegationAddresses(
        signers.owner.address,
        "0x8888888888888888888888888888888888888888",
        "1",
      )
      expect(delegationAddresses[1]).equal("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"); 
    })

    // retrieve Delegators for the delegation address on step1 and check if the delegator exists
    it("#retrieveDelegators", async function () {
      const delegatorAddresses = await contracts.hhDelegation.retrieveDelegators(
        "0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7",
        "0x8888888888888888888888888888888888888888",
        "1",
      )
      expect(delegatorAddresses[0]).equal(signers.owner.address); 
    })

    // retrieve Delegators for the delegation address on step2 and check if the delegator exists
    it("#retrieveDelegators", async function () {
      const delegatorAddresses = await contracts.hhDelegation.retrieveDelegators(
        "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
        "0x8888888888888888888888888888888888888888",
        "1",
      )
      expect(delegatorAddresses[0]).equal(signers.owner.address); 
    })
    
  }) // end of multiple register context

  context("Check Consolidation Status", () => {

    // register a consolidation using the owner address to signers.addr1.address
    it("#registerDelegationForConsolidation", async function () {
      await contracts.hhDelegation.registerDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        signers.addr1.address,
        "1799339953",
        "999",
        "true",
        "0",
      )
    })

    // connect as signers.addr1.address and register a consolidation to owner address
    it("#registerDelegationForConsolidation", async function () {
      await contracts.hhDelegation.connect(signers.addr1).registerDelegationAddress(
        "0x8888888888888888888888888888888888888888",
        signers.owner.address,
        "1799339953",
        "999",
        "true",
        "0",
      )
    })

    // check the Consolidation status
    it("#checkConsolidation", async function () {
      const status = await contracts.hhDelegation.checkConsolidationStatus(
        signers.owner.address,
        signers.addr1.address,
        "0x8888888888888888888888888888888888888888",
      )
      expect(status).equal(true);
    })

  }) // end of consolidation test

    context("Register a Delegation as Delegation Manager", () => {

      // register signers.addr1.address as a delegation manager using the owner address 
      it("#registerDelegationManager", async function () {
        await contracts.hhDelegation.registerDelegationAddress(
          "0x8888888888888888888888888888888888888888",
          signers.addr1.address,
          "1799339953",
          "998",
          "true",
          "0",
        )
      })

      // connect as the delegation manager and register a delegation on behalf of the delegator
      it("#registerDelegationusingDelegationManager", async function () {
        await contracts.hhDelegation.connect(signers.addr1).registerDelegationAddressUsingSubDelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "1799339953",
          "2",
          "true",
          "0",
        )
      })

      // check the status of the delegation
      it("#checkDelegationStatus", async function () {
        const status = await contracts.hhDelegation.retrieveGlobalStatusOfDelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "2",
        )
        expect(status).equal(true); 
      })


  }) // end of subdelegation test

    context("Revoke a Delegation as Delegation Manager", () => {

      // connect as the delegation manager and register a delegation on behalf of the delegator
      it("#registerDelegationusingDelegationManager", async function () {
        await contracts.hhDelegation.connect(signers.addr1).registerDelegationAddressUsingSubDelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "1799339953",
          "11",
          "true",
          "0",
        )
      })

      // check the status of the delegation
      it("#checkDelegationStatus", async function () {
        const status = await contracts.hhDelegation.retrieveGlobalStatusOfDelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "11",
        )
        expect(status).equal(true); 
      })

      // revoke the delegation registered at the pervious step using the delegation manager 
      it("#registerDelegationusingDelegationManager", async function () {
        await contracts.hhDelegation.connect(signers.addr1).revokeDelegationAddressUsingSubdelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "11",
        )
      })

      // check the status of the delegation
      it("#checkDelegationStatus", async function () {
        const status = await contracts.hhDelegation.retrieveGlobalStatusOfDelegation(
          signers.owner.address,
          "0x8888888888888888888888888888888888888888",
          "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
          "11",
        )
        expect(status).equal(false); 
      })

    }) // end revoke as delegation manager

})