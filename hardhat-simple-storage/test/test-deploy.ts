import { ethers } from "hardhat";
import { assert, expect } from "chai"
import { SimpleStorage, SimpleStorage__factory } from "../typechain-types"

describe("SimpleStorage", () => {
    let simpleStorage : SimpleStorage
    let simpleStorageFactory : SimpleStorage__factory

    // Describes what to do before each test
    // In this case it's gonna deploy a brand new contract before each test
    beforeEach(async () => {
        simpleStorageFactory = (await ethers.getContractFactory("SimpleStorage")) as SimpleStorage__factory
        simpleStorage = await simpleStorageFactory.deploy()
    })

    it("Should start with a favorite number of 0", async () => {
        const currentValue = await simpleStorage.retrieve()
        const expectedValue = "0"

        // Using two functions from 'chai' library
        // assert
        // expect

        assert.equal(currentValue.toString(), expectedValue)
    })

    it("Should update when we call store", async () => {
      const expectedValue = "7"
      const transactionResponse = await simpleStorage.store(expectedValue)
      await transactionResponse.wait(1)

      const currentValue = await simpleStorage.retrieve()
      assert.equal(currentValue.toString(), expectedValue)
    })

    it("Should update when we call addPerson", async () => {
        const expectedName = "Alice"
        const expectedValue = "7"

        const transactionResponse = await simpleStorage.addPerson(expectedName, expectedValue)
        await transactionResponse.wait(1)

        const currentValue = await simpleStorage.nameToFavoriteNumber(expectedName)
        assert.equal(currentValue.toString(), expectedValue)
    })
})
