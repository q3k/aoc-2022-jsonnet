local input = importstr 'input.txt';

local recordified = std.strReplace(input, '\n\n', '|');
local elves = [
  [
    std.parseInt(vv)
    for vv in std.split(v, '\n')
    if vv != ''
  ]
  for v in std.split(recordified, '|')
];

local sum(els) = std.foldl(function(a, b) a + b, els, 0);
local max(els) = std.foldl(function(a, b) std.max(a, b), els, els[0]);

local sums = [sum(e) for e in elves];

{
  part1: max(sums),
  part2: sum(std.reverse(std.sort(sums))[0:3]),
}
