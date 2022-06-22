// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IMarketplace.sol"; 


contract Land is ERC721, ERC721Enumerable, Ownable { 
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;



  
  struct LandMetadata{
    uint coordinatesX;
    uint coordinatesY;
  }




  mapping(uint => LandMetadata) public index;
  IMarketplace public marketplace;
  uint public maxSupply;




  constructor(uint _maxSupply, address _marketplace) ERC721("Land","LAND"){
    maxSupply = _maxSupply;
    marketplace = IMarketplace(_marketplace);
  }




  function safeMint(
    address to, 
    uint _coordinatesX,
    uint _coordinatesY
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();        
        _tokenIdCounter.increment();
        index[tokenId].coordinatesX = _coordinatesX;
        index[tokenId].coordinatesY = _coordinatesY;

        _safeMint(to, tokenId);
  }




  function setMarketAddress(address _marketplace) public onlyOwner{
    marketplace = IMarketplace(_marketplace);
  }




  function transferFrom(
    address from,
    address to,
    uint tokenId
  ) public override(ERC721, IERC721){
    require(address(marketplace) != address(0),"El address del market no esta seteado");
    require(!marketplace.assetIdToOrderOpen(tokenId), "This token is in marketplace");
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

   super._transfer(from, to, tokenId);

  }




  // The following functions are overrides required by Solidity.
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
      internal
      override(ERC721, ERC721Enumerable)
  {
      super._beforeTokenTransfer(from, to, tokenId);
  }




  function supportsInterface(bytes4 interfaceId)
      public
      view
      override(ERC721, ERC721Enumerable)
      returns (bool)
  {
      return super.supportsInterface(interfaceId);
  }

}