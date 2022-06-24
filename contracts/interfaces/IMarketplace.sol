// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IMarketplace is Ownable {
    mapping (uint => bool) public assetIdToOrderOpen;
}