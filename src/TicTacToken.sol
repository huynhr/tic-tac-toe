// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

// view functions read from state but don't interact with them they can call pure functions
// pure functions don't read or write to state, and can call other pure functions

contract TicTacToken {
  uint256[9] public board;
  uint256 public turn;

  uint256 internal constant _EMPTY = 0;
  uint256 internal constant _X = 1;
  uint256 internal constant _O = 2;

  function getBoard() public view returns (uint256[9] memory) {
    return board;
  }

  function markSpace(uint256 space, uint256 symbol) public {
    require(_validSymbol(symbol), "Invalid symbol");

    require(_emptySpace(space), "Already marked");

    require(_validTurn(symbol), "Not your turn");

    board[space] = symbol;
    turn++;
  }

  function currentTurn() public view returns (uint256) {
    return turn % 2 == 0 ? _X : _O;
  }

  function _validTurn(uint256 symbol) internal view returns (bool) {
    return symbol == currentTurn();
  }

  function _emptySpace(uint256 space) internal view returns (bool) {
    return board[space] == _EMPTY;
  }
  
  function _validSymbol(uint256 symbol) internal pure returns (bool) {
    return symbol == _X || symbol == _O;
  }

  function _compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }

}