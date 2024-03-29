pragma solidity 0.8.23;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../TicTacToken.sol";

contract Caller {

    TicTacToken internal _ttt;

    constructor(TicTacToken ttt) {
        _ttt = ttt;
    }
    function call() public view returns (address) {
        return _ttt.msgSender();
    }
}

contract User {
  TicTacToken internal _ttt;
  Vm internal _vm;
  address internal _address;

  constructor(address address_, TicTacToken ttt, Vm vm) {
    _address = address_;
    _ttt = ttt;
    _vm = vm;
  }

  function markSpace(uint256 space, uint256 id) public {
    _vm.prank(_address);
    _ttt.markSpace(space, id);
  }
}

contract TicTacTokenTest is DSTest {
  Vm internal _vm = Vm(HEVM_ADDRESS);
  TicTacToken internal _ttt;
  uint256 internal constant _EMPTY = 0;
  uint256 internal constant _X = 1;
  uint256 internal constant _O = 2;
  address internal constant _OWNER = address(1);
  address internal constant _PLAYER_X = address(2);
  address internal constant _PLAYER_O = address(3);

  User internal _playerX;
  User internal _playerO;

  function setUp() public {
    _ttt = new TicTacToken(_OWNER, _PLAYER_X, _PLAYER_O);
    _playerX = new User(_PLAYER_X, _ttt, _vm);
    _playerO = new User(_PLAYER_O, _ttt, _vm);
  }

  function test_contract_owner() public {
    assertEq(_ttt.owner(), _OWNER);
  }

  function test_stores_player_X() public {
        (address playerXAddr,,) = _ttt.games(0);
        assertEq(playerXAddr, _PLAYER_X);
    }

    function test_stores_player_O() public {
        (,address playerOAddr,) = _ttt.games(0);
        assertEq(playerOAddr, _PLAYER_O);
    }

  function test_has_empty_board() public {
    for (uint256 i = 0; i < 9; i++) {
      assertEq(_ttt.getBoard(0)[i], _EMPTY);
    } 
  }

  function test_auth_nonplayer_cannot_mark_space() public {
    _vm.expectRevert("Unauthorized");
    _ttt.markSpace(0, 0);
  }

  function test_auth_playerx_can_mark_space() public {
    _playerX.markSpace(0, 0);

    assertEq(_ttt.getBoard(0)[0], _X);
  }

  function test_auth_playery_can_mark_space() public {
    _playerX.markSpace(0, 0);
    _playerO.markSpace(1, 0);

    assertEq(_ttt.getBoard(0)[1], _O);
  }

  function test_get_board() public {
    uint256[9] memory expected = [_EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY];
    uint256[9] memory actual = _ttt.getBoard(0);

    for (uint256 i = 0; i < 9; i++) {
      assertEq(actual[i], expected[i]);
    }
  }

  function test_can_mark_space_with_X() public {
    _playerX.markSpace(0, 0);
    assertEq(_ttt.getBoard(0)[0], _X);
  }

  function test_can_mark_space_with_O() public {
    _playerX.markSpace(0, 0);
    _playerO.markSpace(1, 0);
    assertEq(_ttt.getBoard(0)[1], _O);
  }

  function test_cannot_overwrite_marked_space() public {
    _playerX.markSpace(0, 0);

    _vm.expectRevert("Already marked");
    _playerO.markSpace(0, 0);
  }

  function test_symbols_must_alternate() public {
    _playerX.markSpace(0, 0);

    _vm.expectRevert("Not your turn");
    _playerX.markSpace(1, 0);
  }

  function test_should_return_correct_turn() public {
    assertEq(_ttt.currentTurn(), _X);
    _playerX.markSpace(0, 0);
    assertEq(_ttt.currentTurn(), _O);
    _playerO.markSpace(1, 0);
    assertEq(_ttt.currentTurn(), _X);
  }

  function test_checks_for_horizontal_win() public {
    _playerX.markSpace(0, 0);
    _playerO.markSpace(3, 0);
    _playerX.markSpace(1, 0);
    _playerO.markSpace(4, 0);
    _playerX.markSpace(2, 0);
    assertEq(_ttt.winner(), _X);
  }

  function test_checks_for_horizontal_win_row2() public {
    _playerX.markSpace(3, 0);
    _playerO.markSpace(0, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(1, 0);
    _playerX.markSpace(5, 0);
    assertEq(_ttt.winner(), _X);
  }

  function test_checks_for_vertical_win() public {
    _playerX.markSpace(1, 0);
    _playerO.markSpace(0, 0);
    _playerX.markSpace(2, 0);
    _playerO.markSpace(3, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(6, 0);
    assertEq(_ttt.winner(), _O);
  }

  function test_checks_for_diag_win() public {
    _playerX.markSpace(0, 0);
    _playerO.markSpace(1, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(3, 0);
    _playerX.markSpace(8, 0);
    assertEq(_ttt.winner(), _X);
  }

  function test_checks_for_anti_diag_win() public {
    _playerX.markSpace(2, 0);
    _playerO.markSpace(1, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(3, 0);
    _playerX.markSpace(6, 0);
    assertEq(_ttt.winner(), _X);
  }

  function test_for_no_winner() public {
    _playerX.markSpace(0, 0);
    _playerO.markSpace(1, 0);
    _playerX.markSpace(2, 0);
    _playerO.markSpace(3, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(6, 0);
    _playerX.markSpace(5, 0);
    _playerO.markSpace(8, 0);
    _playerX.markSpace(7, 0);
    assertEq(_ttt.winner(), _EMPTY);
  }

  function test_empty_board_returns_no_winner() public {
    assertEq(_ttt.winner(), _EMPTY);
  }

  function test_game_in_progress_returns_no_winner() public {
    _playerX.markSpace(1, 0);
    assertEq(_ttt.winner(), _EMPTY);
  }

  function test_reset_board() public {
    _playerX.markSpace(3, 0);
    _playerO.markSpace(0, 0);
    _playerX.markSpace(4, 0);
    _playerO.markSpace(1, 0);
    _playerX.markSpace(5, 0);
    _vm.prank(_OWNER);
    _ttt.resetBoard(0);
    uint256[9] memory expected = [
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY,
        _EMPTY
    ];
    uint256[9] memory actual = _ttt.getBoard(0);

    for (uint256 i = 0; i < 9; i++) {
        assertEq(actual[i], expected[i]);
    }
  }

  function test_msg_sender() public {
    Caller caller1 = new Caller(_ttt);
    Caller caller2 = new Caller(_ttt);
    

    assertEq(_ttt.msgSender(), address(this));

    assertEq(caller1.call(), address(caller1));
    assertEq(caller2.call(), address(caller2));
  }

} 