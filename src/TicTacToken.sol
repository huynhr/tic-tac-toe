// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.23;

// view functions read from state but don't interact with them they can call pure functions
// pure functions don't read or write to state, and can call other pure functions

contract TicTacToken {
  uint256 internal constant _EMPTY = 0;
  uint256 internal constant _X = 1;
  uint256 internal constant _O = 2;

  uint256[9] public board;
  uint256 public turn;
  address public owner;
  address public playerX;
  address public playerO;

  constructor(address _owner, address _playerX, address _playerO) {
    owner = _owner;
    playerX = _playerX;
    playerO = _playerO;
  }


  function resetBoard() public {
    require(msg.sender == owner, "Unauthorized");

    delete board;
  }

  function msgSender() public view returns (address) {
    return msg.sender;
  }

  function getBoard() public view returns (uint256[9] memory) {
    return board;
  }

  function markSpace(uint256 space, uint256 symbol) public {
    require(_validPlayer(), "Unauthorized");

    require(_validSymbol(symbol), "Invalid symbol");

    require(_emptySpace(space), "Already marked");

    require(_validTurn(symbol), "Not your turn");

    board[space] = symbol;
    turn++;
  }

  function currentTurn() public view returns (uint256) {
    return turn % 2 == 0 ? _X : _O;
  }

  function _validPlayer() internal view returns (bool) {
    return msg.sender == playerX || msg.sender == playerO;
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

  function _row(uint256 row) internal view returns (uint256) {
    // we want to check the value of the rows
    require(row < 3, "Invalid row");
    uint256 idx = row * 3;

    return board[idx] * board[idx + 1] * board[idx + 2];
  }

  function _col(uint256 col) internal view returns (uint256) {
    require (col < 3, "Invalid col");
    return board[col] * board[col + 3] * board[col + 6];
  }

  function _diag() internal view returns (uint256) {
    return board[0] * board[4] * board[8];
  }

  function _antiDiag() internal view returns (uint256) {
    return board[2] * board[4] * board[6];
  }

  function _checkWin(uint256 product) internal pure returns (uint256) {
    if (product == 1) {
      return _X;
    }
    
    if (product == 8) {
      return _O;
    }

    return _EMPTY;
  }

  function winner() public view returns (uint256) {
    uint256[8] memory wins = [
      _row(0),
      _row(1),
      _row(2),
      _col(0),
      _col(1),
      _col(2),
      _diag(),
      _antiDiag()
    ];

    for (uint256 i; i < wins.length; i++) {
      uint256 win = _checkWin(wins[i]);
      if (win == _X || win == _O) return win;
    }
    return _EMPTY;

  }

}