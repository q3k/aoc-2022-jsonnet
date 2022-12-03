local input = importstr 'input.txt';
local lines = [l for l in std.split(input, '\n') if l != ''];

local valuearr = ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

local value(el) = std.findSubstr(el, valuearr)[0];
local sum(els) = std.foldl(function(a, b) a + b, els, 0);

local rucksacks = [
  {
    length:: std.length(l),
    compartments: [
      l[:self.length / 2],
      l[self.length / 2:],
    ],
    local r = self,
    part1: {
      c1: std.set(std.stringChars(r.compartments[0])),
      c2: std.set(std.stringChars(r.compartments[1])),
      common: std.setInter(self.c1, self.c2),
      result: sum([value(e) for e in self.common]),
    },
  }
  for l in lines
];
local groups = [
  {
    rucksacks: [rucksacks[n * 3], rucksacks[n * 3 + 1], rucksacks[n * 3 + 2]],
    sets: [
      std.set(std.stringChars(r.compartments[0] + r.compartments[1]))
      for r in self.rucksacks
    ],
    common: std.setInter(std.setInter(self.sets[0], self.sets[1]), self.sets[2]),
    result: value(self.common[0]),
  }
  for n in std.range(0, std.length(rucksacks) / 3 - 1)
];

{
  part1: sum([r.part1.result for r in rucksacks]),
  part2: sum([g.result for g in groups]),
}
