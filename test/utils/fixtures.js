const { deployments, ethers } = require("hardhat");

const initialSetup = deployments.createFixture(
    async({ deployments }) => {
        // Get some users
        const [deployer, user1, user2] = await ethers.getSigners();
        // Deploy contracts
        await deployments.fixture();
        const Land = await ethers.getContractFactory("Land");
        const TestMarketplace = await ethers.getContractFactory("TestMarketplace");
        const landContract = await Land.deploy();
        const marketplace = await TestMarketplace.deploy();
        // Mint some Lands (they need approval)
        await landContract.safeMint(user1.address, 1, 1);
        await landContract.safeMint(user1.address, 3, 3);
        return { contracts: { marketplace, landContract }};
    }
);

module.exports = {
    initialSetup
}