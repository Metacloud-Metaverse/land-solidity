module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    // Deploy Marketplace contract
    await deploy('Land', {
        from: deployer,
        log: true,
        autoMine: true
    });

};

module.exports.tags = ['Land'];