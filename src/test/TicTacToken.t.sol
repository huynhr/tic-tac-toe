pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../TicTacToken.sol";

contract TicTacTokenTest is DSTest {
  Vm internal _vm = Vm(HEVM_ADDRESS);
  TicTacToken internal _ttt;
  uint256 internal constant _EMPTY = 0;
  uint256 internal constant _X = 1;
  uint256 internal constant _O = 2;

  function setUp() public {
    _ttt = new TicTacToken();
  }

  function test_has_empty_board() public {
    for (uint256 i = 0; i < 9; i++) {
      assertEq(_ttt.board(i), _EMPTY);
    }
  }

  function test_get_board() public {
    uint256[9] memory expected = [_EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY, _EMPTY];
    uint256[9] memory actual = _ttt.getBoard();

    for (uint256 i = 0; i < 9; i++) {
      assertEq(actual[i], expected[i]);
    }
  }

  function test_can_mark_space_with_X() public {
    _ttt.markSpace(0, _X);
    assertEq(_ttt.board(0), _X);
  }

  function test_can_mark_space_with_O() public {
    _ttt.markSpace(0, _X);
    _ttt.markSpace(1, _O);
    assertEq(_ttt.board(1), _O);
  }

  function test_cannot_mark_space_with_Z() public {
    _vm.expectRevert("Invalid symbol");
    _ttt.markSpace(0, 3);
  }

  function test_cannot_overwrite_marked_space() public {
    _ttt.markSpace(0, _X);

    _vm.expectRevert("Already marked");
    _ttt.markSpace(0, _O);
  }

  function test_symbols_must_alternate() public {
    _ttt.markSpace(0, _X);

    _vm.expectRevert("Not your turn");
    _ttt.markSpace(1, _X);
  }

  function test_should_return_correct_turn() public {
    assertEq(_ttt.currentTurn(), _X);
    _ttt.markSpace(0, _X);
    assertEq(_ttt.currentTurn(), _O);
    _ttt.markSpace(1, _O);
    assertEq(_ttt.currentTurn(), _X);
  }

} 