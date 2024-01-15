// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.23;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import "../Bowling.sol";

// bowling rules
// to make it simple let's just do one roll per round, and a strike at the end does not grant you extra rolls
// only max of 10 rounds per game so index based 0 - 9
// if you roll a strike, then you get a bonus on the next two rounds

// how do we want to handle rounds?

contract BowlingTest is DSTest {
  Bowling internal _bowling;

  function setUp() public {
    _bowling = new Bowling();
  }

  function test_returns_default_score() public {
    assertEq(_bowling.score(), 0);
  }

  function test_roll() public {
    _bowling.roll(5, 0);
    _bowling.roll(7, 1);
    assertEq(_bowling.score(), 12);
  }

  function test_all_rounds() public {
    _bowling.roll(5, 0);
    _bowling.roll(6, 1);
    _bowling.roll(7, 2);
    _bowling.roll(8, 3);
    _bowling.roll(9, 4);
    _bowling.roll(1, 5);
    _bowling.roll(2, 6);
    _bowling.roll(3, 7);
    _bowling.roll(4, 8);
    _bowling.roll(5, 9);

    assertEq(_bowling.score(), 50);
  }

  function test_handle_strike() public {
    _bowling.roll(10, 0); //10 + 9, 5, 4, = 28
    _bowling.roll(5, 1);
    _bowling.roll(4, 2);

    assertEq(_bowling.score(), 28);
  }

  function test_handle_multiple_strikes() public {
    _bowling.roll(5, 0);
    _bowling.roll(4, 1);
    _bowling.roll(10, 2); //27
    _bowling.roll(7, 3);
    _bowling.roll(10, 4); // 30
    _bowling.roll(10, 5); // 23
    _bowling.roll(10, 6); //23
    _bowling.roll(3, 7);
    _bowling.roll(10, 8); //16
    _bowling.roll(6, 9);

    assertEq(_bowling.score(), 144);
  }
}