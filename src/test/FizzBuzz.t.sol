// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../FizzBuzz.sol";


contract FizzBuzzTest is DSTest {
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    }

    function test_returns_fizz_when_divisible_by_three() public {
        assertEq(fizzbuzz.fizzbuzz(3), "fizz");
        assertEq(fizzbuzz.fizzbuzz(6), "fizz");
        assertEq(fizzbuzz.fizzbuzz(27), "fizz");
    }

    function test_returns_buzz_when_divisible_by_five() public {
        assertEq(fizzbuzz.fizzbuzz(5), "buzz");
        assertEq(fizzbuzz.fizzbuzz(10), "buzz");
        assertEq(fizzbuzz.fizzbuzz(175), "buzz");
    }

    function test_returns_buzz_when_divisible_by_three_and_five() public {
        assertEq(fizzbuzz.fizzbuzz(15), "fizzbuzz");
        assertEq(fizzbuzz.fizzbuzz(30), "fizzbuzz");
        assertEq(fizzbuzz.fizzbuzz(45), "fizzbuzz");
    }

    function test_returns_number_when_not_divisible_by_three_or_five() public {
        assertEq(fizzbuzz.fizzbuzz(1), "1");
    }
}
