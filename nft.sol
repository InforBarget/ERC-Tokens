// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MonNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    string private _baseTokenURI;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintPrice = 0.05 ether;
    
    constructor() ERC721("Mon NFT", "MNFT") {
        _baseTokenURI = "ipfs://QmXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/";
    }
    
    function mint() public payable returns (uint256) {
        require(_tokenIds.current() < MAX_SUPPLY, "Max supply atteint");
        require(msg.value >= mintPrice, "Prix insuffisant");
        
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _safeMint(msg.sender, newTokenId);
        
        return newTokenId;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }
    
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}
