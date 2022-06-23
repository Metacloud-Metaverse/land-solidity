// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IMarketplace.sol"; 


contract Land is ERC721, ERC721Enumerable, Ownable { 
    using Address for address;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct LandMetadata{
        uint256 coordinatesX;
        uint256 coordinatesY;
    }

    mapping(uint256 => LandMetadata) public landIndexToMetadata;
    IMarketplace public marketplace;
    uint256 public immutable maxSupply = 10000;

    constructor() ERC721("Land","LAND") {}

    function safeMint(
        address _to, 
        uint256 _coordinatesX,
        uint256 _coordinatesY
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "ERC721: minting would exceed total supply");
        _tokenIdCounter.increment();
        // Save Land metadata
        landIndexToMetadata[tokenId] = LandMetadata({
            coordinatesX: _coordinatesX,
            coordinatesY: _coordinatesY
        });
        _safeMint(_to, tokenId);
    }

    function setMarketAddress(address _marketplace) public onlyOwner {
        require(_marketplace != address(0), "Marketplace address cannot be 0");
        require(_marketplace.isContract(), "Marketplace address must be a deployed contract");
        marketplace = IMarketplace(_marketplace);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721){
        require(address(marketplace) != address(0),"Marketplace address is not setted");
        require(!marketplace.assetIdToOrderOpen(tokenId), "Land has an open order in Marketplace, cancel before transfer");
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        super._transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override(ERC721, IERC721) {
        transferFrom(from, to, tokenId);
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