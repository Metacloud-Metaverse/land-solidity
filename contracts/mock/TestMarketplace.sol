// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../Land.sol";


contract TestMarketplace {
    mapping (uint => bool) public assetIdToOrderOpen;

    function createOrder(uint256 _assetId) external {
        require(!assetIdToOrderOpen[_assetId], "Duplicate order");
        assetIdToOrderOpen[_assetId] = true;
    }
}