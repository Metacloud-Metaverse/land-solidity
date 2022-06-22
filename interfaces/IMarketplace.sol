// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

// TODO: overwrite ERC721 transferFrom function, checking first if there are
// any open order for that Land. Revert saying that he have to cancel orders first.

contract IMarketplace is Ownable, Pausable {
  mapping (uint => bool) public assetIdToOrderOpen;
}