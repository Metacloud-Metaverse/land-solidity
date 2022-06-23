const { expect } = require('chai');
const { ethers } = require("hardhat");
const { initialSetup } = require("./utils/fixtures");

describe("Lands", () => {
    // Define variables for the contract instances
    let marketplace, landContract;
    // Define variables for accounts to interact with contracts
    let deployer, user1, user2;

    beforeEach(async () => {
        // Get contracts instances from fixture
        const { contracts } = await initialSetup();
        ({ marketplace, landContract } = contracts);
        [deployer, user1, user2] = await ethers.getSigners();
    });

    describe("Initial setup", () => {
        it("Should verify that deployer is the owner of Land contract", async () => {
            expect(
                await landContract.owner()
            ).to.equal(deployer.address);
        });

        it("Should verify that total supply is 10.000");
    });

    describe("Minting", () => {
        it("Should let the owner mint a Land");

        it("Should revert trying to mint a Land without being the owner");

        it("Should verify Land metadata");
    });

    describe("Transfering", () => {
        it("Should revert trying to transfer a Land without setting the marketplace address");
        
        it("Should revert trying to transfer a Land with an open order in the marketplace");

        it("Should transfer a Land successfully");
    });
});