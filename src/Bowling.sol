// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.23;

// import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract Bowling {
  uint256 public constant MAX_ROUNDS = 9;
  uint256 public currentRound = 0;
  mapping(uint256 => uint256) public gameScore;

  function getCurrentRound() public view returns (uint256) {
    return currentRound;
  }


  function score() public view returns (uint256) {
    uint256 total = 0;
    for (uint256 i = 0; i < currentRound; i++) {
      total += gameScore[i];
    }
    return total;
  }

  function roll(uint256 pins, uint256 round) public returns (uint256) {
    if (round != currentRound) {
      revert("Invalid round");
    }

    if (round > MAX_ROUNDS) {
      revert("Game is over");
    }

    // a strike is, the strike round gets a bonus for the value of that next two rolls
    // so if I roll a 10, 5, 6, then it would be 10, bonus 11 + 5 + 6 = 32 
    
    // check if the previous two rounds have a 10
    // if the two rounds ago are a 10, total the current round and previous round and add it to the strike round and mapp the current round value
    // if we're round 9 and prevoius round was a 10 then just give the bonus of round 9 to round 8
    // if we're round 0 don't look back

    if (round == 0) {
      gameScore[round] = pins;
      currentRound++;
      return gameScore[round];
    }

    if (round == 1) {
      gameScore[round] = pins;
      currentRound++;
      return gameScore[round];
    }

    if (round == 9) {
      uint256 onePrevoiusRound = gameScore[round - 1];
      if (onePrevoiusRound == 10) {
        gameScore[round - 1] = onePrevoiusRound + pins;
        gameScore[round] = pins;
        currentRound++;

        return gameScore[round];
      }
    }

    uint256 onePrevoiusRound = gameScore[round - 1];
    uint256 twoPreviousRound = gameScore[round - 2];

    if (twoPreviousRound == 10) {
      gameScore[round - 2] = twoPreviousRound + onePrevoiusRound + pins;
      gameScore[round] = pins;
      currentRound++;

      return gameScore[round];
    }

    gameScore[round] = pins;
    currentRound++;
    return gameScore[round];
  }
}