const { expect } = require("chai")
const { ethers } = require("hardhat")

const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers")

const GLOBAL_DELEGATION = "0x8888888888888888888888888888888888888888"

const deployScaffold = async () => {
  const nftDelegations = await ethers.getContractFactory(
    "delegationManagementContract",
  )
  const hhDelegationManagement = await nftDelegations.deploy(
  )

  return { hhDelegationManagement }
}

describe("DelegationManagement", () => { 
  let hhDelegationManagement
  before(async () => {
    ;({ hhDelegationManagement } =
      await loadFixture(deployScaffold))
    ;[owner, addr1, addr2, addr3, addr4] = await ethers.getSigners()
  })

  context("Global Delegations", () => {
    beforeEach(async () => {

    })

    describe("Delegate all to another address", () => {
      it("succeeds", async () => {
        
        await expect(
          hhDelegationManagement.connect(addr1).registerDelegationAddress(GLOBAL_DELEGATION, addr2.address, 9999999999, 1, true, 0),
        ).to.not.be.reverted

        expect((await hhDelegationManagement.retrieveActiveDelegators(addr2.address, GLOBAL_DELEGATION, 0, 1))[0]).to.equal(addr1.address)

      })
    })

    describe("Batch delegation", () => {
      it("Assign usage 1 to 10 to addr and 11 to 17 to addr2", async () => {
        
        const global17Times = 
          [GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION,
          GLOBAL_DELEGATION, 
          GLOBAL_DELEGATION,
          GLOBAL_DELEGATION,
          GLOBAL_DELEGATION,
          GLOBAL_DELEGATION,
          GLOBAL_DELEGATION]

        const delegationAddresses = 
        [addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr2.address,
        addr3.address,
        addr3.address,
        addr3.address,
        addr3.address,
        addr3.address,
        addr3.address]  

        const nonExpiring = 
        [9999999999,9999999999,9999999999,9999999999,9999999999,9999999999,9999999999,9999999999, 9999999999,
          9999999999,9999999999,9999999999,9999999999,9999999999,9999999999,9999999999]

        const alltokens = 
        [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]

        const tokenIds = 
        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

        const useCases = 
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]

        await expect(
          hhDelegationManagement.connect(addr1).batchDelegations(global17Times, delegationAddresses, nonExpiring, useCases, alltokens, tokenIds),
          ).to.not.be.reverted


      })
    })
  })

  context("Filtering", () => {
    beforeEach(async () => {

    })

    describe("Validity Dates", () => {
      it("Correct result set for expired delegations", async () => {
                
        await expect(
          hhDelegationManagement.connect(addr3).registerDelegationAddress(GLOBAL_DELEGATION, addr4.address, 0, 1, true, 0),
        ).to.not.be.reverted

        expect((await hhDelegationManagement.retrieveActiveDelegators(addr4.address, GLOBAL_DELEGATION, 0, 1))[0]).to.equal(undefined)

      })
    })
  })

})
