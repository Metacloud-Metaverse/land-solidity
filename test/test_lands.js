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

        it("Should verify that total supply is 10.000", async () => {
            expect(
                await landContract.maxSupply()
            ).to.equal(10000);
        });
    });

    describe("Minting", () => {
        it("Should let the owner mint a Land", async () =>  {
            // Mint a Land as contract owner
            await landContract.safeMint(user1.address, 1, 1);
            // Verify that the owner has 1 Land
            expect(
                await landContract.balanceOf(user1.address)
            ).to.equal(1);
        });

        it("Should revert trying to mint a Land without being the owner", async() => {
            await expect(
                landContract.connect(user1).safeMint(user1.address, 1, 1)
            ).to.be.revertedWith("Ownable: caller is not the owner");
        });

        it("Should verify Land metadata", async () => {
            // Mint a Land as contract owner
            await landContract.safeMint(user1.address, 7, 13);
            // Verify the coordenates of minted Land
            const [coord_X, coord_Y] = await landContract.landIndexToMetadata(0);
            expect(coord_X).to.equal(7)
            expect(coord_Y).to.equal(13)
        });
    });

    describe("Transfering", () => {
        it("Should revert trying to transfer a Land without setting the marketplace address", async () => {
            await expect(
                landContract.transferFrom(user1.address, user2.address, 1)
            ).to.be.revertedWith("Marketplace address is not set");
        });
        
        it("Should revert trying to transfer a Land with an open order in the marketplace", async () => {
            // Mint a Land as contract owner
            await landContract.safeMint(user1.address, 1, 1);
            // Set marketplace address
            await landContract.setMarketAddress(marketplace.address);
            // Open an order for the Land
            await marketplace.createOrder(0);
            // Try to transfer the Land
            await expect(
                landContract.connect(user1).transferFrom(user1.address, user2.address, 0)
            ).to.be.revertedWith("Land: there is an open order in the marketplace");
            // Verify that the Land still belongs to user1
            expect(
                await landContract.ownerOf(0)
            ).to.be.equal(user1.address);
            expect(
                await landContract.balanceOf(user1.address)
            ).to.equal(1);
            expect(
                await landContract.balanceOf(user2.address)
            ).to.equal(0);
        });

        it("Should transfer a Land successfully", async () => {
            await landContract.safeMint(user1.address, 1, 1);
            await landContract.setMarketAddress(marketplace.address);
            await marketplace.createOrder(0);
            // Try to transfer the Land
            await expect(
                landContract.connect(user1).transferFrom(user1.address, user2.address, 0)
            ).to.be.revertedWith("Land: there is an open order in the marketplace");
            // Cancel order on marketplace
            await marketplace.cancelOrder(0);
            // Try to transfer the Land
            await landContract.connect(user1).transferFrom(user1.address, user2.address, 0);
            // Verify that the Land now belongs to user2
            expect(
                await landContract.ownerOf(0)
            ).to.be.equal(user2.address);
            expect(
                await landContract.balanceOf(user1.address)
            ).to.equal(0);
            expect(
                await landContract.balanceOf(user2.address)
            ).to.equal(1);
        });
    });
});