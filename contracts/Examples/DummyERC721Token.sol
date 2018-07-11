pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";


/**
 * @title MintableNonFungibleToken
 *
 * Superset of the ERC721 standard that allows for the minting
 * of non-fungible tokens.
 */
contract DummyERC721Token is ERC721Token {
    using SafeMath for uint;

    // An ERC721 token that allows you to mint the number of tokens you want in
    // the constructor
    constructor(uint _tokenNumber, string _name, string _symbol)
    public ERC721Token(_name, _symbol) {
        for (uint i = 0; i < _tokenNumber; i++)
            super._mint(msg.sender, i);
    }
}
