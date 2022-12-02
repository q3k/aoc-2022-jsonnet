local input = importstr 'input.txt';
local lines = [l for l in std.split(input, '\n') if l != ''];
local beats = {
  rock: 'scissors',
  paper: 'rock',
  scissors: 'paper',
};
local beatenBy = {
  scissors: 'rock',
  rock: 'paper',
  paper: 'scissors',
};
local win(you, opponent) = if beats[you] == opponent then 'win'
else if beats[opponent] == you then 'loss'
else 'draw';
local parseline(line) = {
  opponent: {
    A: 'rock',
    B: 'paper',
    C: 'scissors',
  }[line[0]],
  local opponent = self.opponent,
  local calculate = {
    choice: error 'choice needs to be specified',
    choicePoints: {
      rock: 1,
      paper: 2,
      scissors: 3,
    }[self.choice],
    result: win(self.choice, opponent),
    points: {
      win: 6,
      draw: 3,
      loss: 0,
    }[self.result] + self.choicePoints,
  },
  part1: calculate {
    choice: {
      X: 'rock',
      Y: 'paper',
      Z: 'scissors',
    }[line[2]],
  },
  part2: calculate {
    choice: {
      X: beats[opponent],
      Y: opponent,
      Z: beatenBy[opponent],
    }[line[2]],
  },
};
local rounds = [parseline(l) for l in lines];

local sum(els) = std.foldl(function(a, b) a + b, els, 0);

{
  part1: sum([r.part1.points for r in rounds]),
  part2: sum([r.part2.points for r in rounds]),
}
