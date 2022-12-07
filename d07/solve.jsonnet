local input = importstr 'input.txt';
// directory template with automatically calculated size.
local dir(name) = {
  name: name,
  type: 'dir',
  children: {},
  // jsonnet magic here.
  size: std.foldl(function(a, b) (a + b), [c.size for c in std.objectValues(self.children)], 0),
};
// parse line into command.
local lines = [
  local parts = std.split(l, ' ');
  if parts[:2] == ['$', 'cd'] then {
    type: 'cd',
    arg: parts[2],
  } else if parts[:2] == ['$', 'ls'] then {
    type: 'spurious',
  } else if parts[0] == 'dir' then {
    type: 'info',
    template: dir(parts[1]),
    size: 0,
  } else {
    type: 'info',
    template: {
      name: parts[1],
      type: 'file',
      size: std.parseInt(parts[0]),
    },
  }
  for l in std.split(input, '\n')
  if l != ''
];

// insert value into object at path.
local insert(root, path, value) = (
  if std.length(path) == 0 then error 'empty pathlist'
  else if std.length(path) == 1 then root {
    [path[0]]: value,
  } else root {
    local empty = root {
      [path[0]]+: {},
    },
    [path[0]]: insert(empty[path[0]], path[1:], value),
  }
);
// insert into filesystem state based on a parsed line.
local parse(state, l) =
  (if l.type == 'cd' then (
     state {
       curdir: (
         if l.arg == '/' then ['/']
         else if l.arg == '..' then state.curdir[:std.length(state.curdir) - 1]
         else state.curdir + [l.arg]
       ),
     }
   ) else if l.type == 'info' then (
     state {
       local path = std.flattenArrays([[p, 'children'] for p in state.curdir]) + [l.template.name],
       root: insert(state.root, path, l.template),
     }
   ) else state);
// build filesystem state.
local parsed = std.foldl(parse, lines, {
  curdir: [],
  root: {
    '/': dir('/'),
  },
});
// get flat list of all files/directories.
local flatten(dir) = std.flatMap(function(c)
  (
    if c.type == 'file' then [c]
    else flatten(c) + [c { children+:: {} }]
  ), std.objectValues(dir.children));
local flattened = flatten(parsed.root['/']);

{
  part1: {
    small:: [f for f in flattened if f.size <= 100000 && f.type == 'dir'],
    result: std.foldl(function(a, b) a + b.size, self.small, 0),
  },
  part2: {
    needed:: parsed.root['/'].size - 40000000,
    filtered:: [s for s in flattened if s.size >= self.needed && s.type == 'dir'],
    sorted:: std.sort(self.filtered, function(k) k.size),
    result: self.sorted[0].size,
  },
}
