// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IMarketplace.sol"; 


contract Land is ERC721Enumerable, Ownable { 
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;



  
  struct LandMetadata{
    uint256 coordinatesX;
    uint256 coordinatesY;
  }




  mapping(uint256 => LandMetadata) public index;
  IMarketplace public marketplace;
  uint256 public maxSupply;




  constructor() ERC721("Land","LAND"){
  }




  function safeMint(
    address to, 
    uint256 _coordinatesX,
    uint256 _coordinatesY
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();        
        index[tokenId] = LandMetadata({
            coordinatesX: _coordinatesX,
            coordinatesY: _coordinatesY
        });

        _safeMint(to, tokenId);
  }




  function setMarketAddress(address _marketplace) public onlyOwner{
    marketplace = IMarketplace(_marketplace);
  }




  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public override(ERC721, IERC721){
    require(address(marketplace) != address(0),"Address of marketplace is not set");
    require(!marketplace.assetIdToOrderOpen(tokenId), "This token is in marketplace");
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

   super._transfer(from, to, tokenId);

  }




  // The following functions are overrides required by Solidity.
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
      internal
      override(ERC721Enumerable)
  {
      super._beforeTokenTransfer(from, to, tokenId);
  }




  function supportsInterface(bytes4 interfaceId)
      public
      view
      override(ERC721Enumerable)
      returns (bool)
  {
      return super.supportsInterface(interfaceId);
  }

}