// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import "../FizzBuzz.sol";

contract FizzBuzzTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    }

    // property based testing
    function test_returns_fizz_when_divisible_by_three(uint256 n) public {
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 != 0);
        assertEq(fizzbuzz.fizzbuzz(n), "fizz");
    }

    function test_returns_buzz_when_divisible_by_five(uint256 n) public {
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 == 0);
        assertEq(fizzbuzz.fizzbuzz(n), "buzz");
    }

    function test_returns_fizzbuzz_when_divisible_by_three_and_five(uint256 n) public {
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 == 0);
        assertEq(fizzbuzz.fizzbuzz(n), "fizzbuzz");
    }

    function test_returns_number_when_not_divisible_by_three_or_five(uint256 n) public {
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 != 0);

        assertEq(fizzbuzz.fizzbuzz(n), Strings.toString(n));
    }
}
