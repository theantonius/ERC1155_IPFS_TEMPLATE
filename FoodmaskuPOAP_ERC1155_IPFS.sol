// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';
import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FoodmaskuPOAP is ERC1155Supply, Ownable {
  using Strings for string;
  using SafeMath for uint256;

  uint256 public _currentTokenID = 0;
  mapping (uint256 => string) public tokenURIs;

  // Contract name
  string public name;
  // Contract symbol
  string public symbol;
  // Base metadata uri
  string public baseURI;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _baseURI
  ) ERC1155 ("") {
    name = _name;
    symbol = _symbol;
    baseURI = _baseURI;
  }

  function uri(
    uint256 _id
  ) public view override returns (string memory) {
    require(exists(_id), "ERC1155: NONEXISTENT_TOKEN");
    return string(abi.encodePacked(baseURI, tokenURIs[_id]));
  }

  /**
   * @dev Will update the base URL of token's URI
   * @param _baseURI New base URL of token's URI
  */
  function setBaseURI(
    string memory _baseURI
  ) public onlyOwner {
    baseURI = _baseURI;
  }

  /**
    * @dev Creates a new token type and assigns _initialSupply to an address
    * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
    * @param _initialOwner address of the first owner of the token
    * @param _initialSupply amount to supply the first owner
    * @param _uri URI for this token type
    * @return The newly created token ID
  */
  function create(
    address _initialOwner,
    uint256 _initialSupply,
    string calldata _uri
  ) external onlyOwner returns (uint256) {

    uint256 _id = _currentTokenID.add(1);
    _currentTokenID++;

    if (bytes(_uri).length > 0) {
      emit URI(_uri, _id);
    }

    _mint(_initialOwner, _id, _initialSupply, "0x00");
    tokenURIs[_id] = _uri;
    return _id;
  }

  /**
    * @dev Mints some amount of tokens to an address
    * @param _to          Address of the future owner of the token
    * @param _id          Token ID to mint
    * @param _quantity    Amount of tokens to mint
  */
  function mint(
    address _to,
    uint256 _id,
    uint256 _quantity
  ) external onlyOwner {
    _mint(_to, _id, _quantity, "0x00");
  }

  /**
    * @dev Mint tokens for each id in _ids
    * @param _to          The address to mint tokens to
    * @param _ids         Array of ids to mint
    * @param _quantities  Array of amounts of tokens to mint per id
  */
  function mintBatch(
    address _to,
    uint256[] memory _ids,
    uint256[] memory _quantities
  ) external onlyOwner {
    _mintBatch(_to, _ids, _quantities, "0x00");
  }
  
  /**
   * @dev Update a token's URI at any point
   * @param _id          Token ID to update URI
   * @param _uri         URI for this token type
  **/
  function setURI(
    uint256 _id,
    string calldata _uri
  ) external onlyOwner {
    tokenURIs[_id] = _uri;
  }

}
