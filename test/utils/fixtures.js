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
        return { contracts: { marketplace, landContract }};
    }
);

module.exports = {
    initialSetup
}