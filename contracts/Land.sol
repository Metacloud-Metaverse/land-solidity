// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LAND is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    Ownable
{
    using Counters for Counters.Counter;

    IERC20 public cloud;
    address public house;

    uint256 public cloudPrice;
    uint256 public bnbPrice;

    Counters.Counter private _tokenIdCounter;

    constructor(
        IERC20 _cloud,
        address _house,
        uint256 _cloudPrice,
        uint256 _bnbPrice
    ) ERC721("Land", "LAND") {
        cloud = _cloud;
        house = _house;
        cloudPrice = _cloudPrice;
        bnbPrice = _bnbPrice;
    }

    //Mint reserved for the owner
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //  Mint with ERC-20 (CLOUD TOKEN)
    function safeMintWithCloud(address to, string memory uri) public {
        // Requirement: the user have the token CLOUD
        require(
            cloud.balanceOf(msg.sender) >= cloudPrice,
            "You dont have balance"
        );

        // Transfer the cloud token to where it is required. For example: project address 'Metacloud' so that the Land ID can be automatically generated for the user who bought it.
        require(cloud.transferFrom(msg.sender, house, cloudPrice));

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // Mint with BNB
    function safeMintWithBNB(address to, string memory uri) public payable {
        require(msg.value >= bnbPrice, "You dont have balance");
        payable(address(house)).transfer(msg.value);

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function setCloud(IERC20 _cloud) public {
        cloud = _cloud;
    }

    function sethouse(address _house) public {
        house = _house;
    }

    function setCloudPrice(uint256 _cloudPrice) public {
        cloudPrice = _cloudPrice;
    }

    function setBnbPrice(uint256 _bnbPrice) public {
        bnbPrice = _bnbPrice;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
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
