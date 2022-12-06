local input = importstr 'input.txt';
local chars = std.stringChars(input);

local markers(len) = [
  local start = end - len;
  local sub = chars[start:end];
  local unique = std.set(sub);
  std.length(unique) == std.length(sub)
  for end in std.range(len, std.length(chars) - 1)
];

{
  part1: 4 + std.find(true, markers(4))[0],
  part2: 14 + std.find(true, markers(14))[0],
}
