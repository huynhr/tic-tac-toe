// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.23;

// view functions read from state but don't interact with them they can call pure functions
// pure functions don't read or write to state, and can call other pure functions

contract TicTacToken {
    address public owner;

    struct Game {
        address playerX;
        address playerO;
        uint256 turns;
        uint256[9] board;
    }
    mapping(uint256 => Game) public games;

    uint256 internal constant EMPTY = 0;
    uint256 internal constant X = 1;
    uint256 internal constant O = 2;
    uint256 internal _turns;

    constructor(address _owner, address _playerX, address _playerO) {
        owner = _owner;
        games[0].playerX = _playerX;
        games[0].playerO = _playerO;
    }

    function getBoard(uint256 id) public view returns (uint256[9] memory) {
        return games[id].board;
    }

    function resetBoard(uint256 id) public {
        require(
            msg.sender == owner,
            "Unauthorized"
        );
        delete games[id].board;
    }

    function markSpace(uint256 space, uint256 id) public {
        require(_validPlayer(), "Unauthorized");
        require(_validTurn(), "Not your turn");
        require(_emptySpace(space), "Already marked");
        games[id].board[space] = _getSymbol(msg.sender);
        games[id].turns++;
    }

    function currentTurn() public view returns (uint256) {
        return (games[0].turns % 2 == 0) ? X : O;
    }

    function msgSender() public view returns (address) {
        return msg.sender;
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
            if (win == X || win == O) return win;
        }
        return 0;
    }

    function _getSymbol(address player) public view returns (uint256) {
        if (player == games[0].playerX) return X;
        if (player == games[0].playerO) return O;
        return EMPTY;
    }

    function _validTurn() internal view returns (bool) {
        return currentTurn() == _getSymbol(msg.sender);
    }

    function _validPlayer() internal view returns (bool) {
        return msg.sender == games[0].playerX || msg.sender == games[0].playerO;
    }

    function _checkWin(uint256 product) internal pure returns (uint256) {
        if (product == 1) {
            return X;
        }
        if (product == 8) {
            return O;
        }
        return 0;
    }

    function _row(uint256 row) internal view returns (uint256) {
        require(row < 3, "Invalid row");
        uint256 idx = 3 * row;
        return games[0].board[idx] * games[0].board[idx + 1] * games[0].board[idx + 2];
    }

    function _col(uint256 col) internal view returns (uint256) {
        require(col < 3, "Invalid column");
        return games[0].board[col] * games[0].board[col + 3] * games[0].board[col + 6];
    }

    function _diag() internal view returns (uint256) {
        return games[0].board[0] * games[0].board[4] * games[0].board[8];
    }

    function _antiDiag() internal view returns (uint256) {
        return games[0].board[2] * games[0].board[4] * games[0].board[6];
    }

    function _validTurn(uint256 symbol) internal view returns (bool) {
        return symbol == currentTurn();
    }

    function _emptySpace(uint256 i) internal view returns (bool) {
        return games[0].board[i] == EMPTY;
    }

    function _validSymbol(uint256 symbol) internal pure returns (bool) {
        return symbol == X || symbol == O;
    }
}

