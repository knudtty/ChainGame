// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@rari-capital/solmate/src/tokens/ERC721.sol";

abstract contract ChainGame is ERC721 {
    struct GameItem {
        bytes bytecode;
        address creator;
        bytes32 bytecodeHash;
    }
    uint256 totalSupply;
    mapping(bytes32 => bool) gameItemsTaken;
    mapping(uint256 => GameItem) internal _gameItems;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        totalSupply = 0;
    }

    function registerGameItem(bytes calldata gameItemBytes) public {
        require(!gameItemsTaken[keccak256(gameItemBytes)], "Game item taken");
        _gameItems[totalSupply] = GameItem({
            bytecode: gameItemBytes,
            creator: msg.sender,
            bytecodeHash: keccak256(gameItemBytes)
        });

        _safeMint(msg.sender, totalSupply);
        totalSupply++;
    }

    function getGameItem(uint256 tokenId)
        public
        view
        returns (GameItem memory gameItem)
    {
        require(tokenId < totalSupply, "NOT_MINTED");
        gameItem = _gameItems[tokenId];
    }
}
