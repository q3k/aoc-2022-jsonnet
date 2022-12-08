// warning: slow and terrible

local input = importstr 'input.txt';
local grid = [
  [
    std.parseInt(c)
    for c in std.stringChars(l)
  ]
  for l in std.split(input, '\n')
  if l != ''
];
local visible(arr) = std.foldl(function(s, t) (
  if t.el > s.h then {
    h: t.el,
    offs: s.offs + [t.i],
  } else s
), std.mapWithIndex(function(i, el) { el: el, i: i }, arr), { h: -1, offs: [] });

local column(n) = [
  grid[i][n]
  for i in std.range(0, std.length(grid) - 1)
];
local columns = [
  column(i)
  for i in std.range(0, std.length(grid[0]) - 1)
];
local sum(arr) = std.foldl(function(a, b) a + b, arr, 0);
local max(arr) = std.foldl(function(a, b) std.max(a, b), arr, 0);

local blocking(arr) = std.foldl(function(state, t) (
  local h = t.el;
  local withpos = state {
    pos+: {
      [std.toString(h)]: t.i,
    },
  };
  if state.pos == {} then withpos {
    res: state.res + [0],
  } else withpos {
    local v = max([state.pos[std.toString(i)] for i in std.range(h, 9)]),
    local d = if v == -1 then t.i else t.i - v,
    res: state.res + [d],
  }
), std.mapWithIndex(function(i, el) { el: el, i: i }, arr), { pos: {
  [std.toString(i)]: -1
  for i in std.range(0, 9)
}, res: [] }).res;

{
  part1: {
    rowsL:: std.flattenArrays([['%d,%d' % [x, y] for x in visible(grid[y]).offs] for y in std.range(0, std.length(grid) - 1)]),
    rowsR:: std.flattenArrays([['%d,%d' % [std.length(columns) - (x + 1), y] for x in visible(std.reverse(grid[y])).offs] for y in std.range(0, std.length(grid) - 1)]),
    colsT:: std.flattenArrays([['%d,%d' % [x, y] for y in visible(columns[x]).offs] for x in std.range(0, std.length(columns) - 1)]),
    colsB:: std.flattenArrays([['%d,%d' % [x, std.length(grid) - (y + 1)] for y in visible(std.reverse(columns[x])).offs] for x in std.range(0, std.length(columns) - 1)]),
    unique:: std.set(self.rowsL + self.rowsR + self.colsT + self.colsB),
    result: std.length(self.unique),
  },
  part2: {
    local rowsL = [blocking(r) for r in grid],
    local rowsR = [blocking(std.reverse(r)) for r in grid],
    local colsT = [blocking(c) for c in columns],
    local colsB = [blocking(std.reverse(c)) for c in columns],
    scores:: [
      [
        local rl = rowsL[y][x];
        local rr = rowsR[y][std.length(columns) - (x + 1)];
        local ct = colsT[x][y];
        local cb = colsB[x][std.length(grid) - (y + 1)];
        rl * rr * ct * cb
        for x in std.range(0, std.length(columns) - 1)
      ]
      for y in std.range(0, std.length(grid) - 1)
    ],
    result: max([max(r) for r in self.scores]),
  },
}
