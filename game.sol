// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameItems is ERC1155, Ownable {
    // IDs des tokens
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant SWORD = 2;
    uint256 public constant SHIELD = 3;
    uint256 public constant LEGENDARY_SWORD = 4;
    
    mapping(uint256 => uint256) public tokenSupply;
    mapping(uint256 => uint256) public maxSupply;
    
    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        // Définir les max supply
        maxSupply[GOLD] = type(uint256).max; // Illimité
        maxSupply[SILVER] = type(uint256).max; // Illimité
        maxSupply[SWORD] = 1000; // Limité
        maxSupply[SHIELD] = 500; // Limité
        maxSupply[LEGENDARY_SWORD] = 1; // Unique (NFT)
    }
    
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        require(
            tokenSupply[id] + amount <= maxSupply[id],
            "Max supply atteint"
        );
        
        tokenSupply[id] += amount;
        _mint(to, id, amount, data);
    }
    
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        for (uint256 i = 0; i < ids.length; i++) {
            require(
                tokenSupply[ids[i]] + amounts[i] <= maxSupply[ids[i]],
                "Max supply atteint"
            );
            tokenSupply[ids[i]] += amounts[i];
        }
        
        _mintBatch(to, ids, amounts, data);
    }
    
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(
            abi.encodePacked(
                "https://game.example/api/item/",
                Strings.toString(tokenId),
                ".json"
            )
        );
    }
}
