local input = importstr "input.txt";
local lines = [i for i in std.split(input, "\n") if i != ""];

local Interval(a, b) = {
    a: a,
    b: b,

    local i = self,
    contains(o):: i.a <= o.a && i.b >= o.b,
    overlaps(o):: i.a <= o.b && o.a <= i.b,
};

local pairs = [
    local parts = std.split(l, ",");
    local ranges = [
        {
            local parts = std.split(p, "-"),
            a: std.parseInt(parts[0]),
            b: std.parseInt(parts[1]),
        }
        for p in parts
    ];
    {
        left: Interval(ranges[0].a, ranges[0].b),
        right: Interval(ranges[1].a, ranges[1].b),
    }
    for l in lines
];

{
    part1: std.length([
        true
        for p in pairs
        if (p.left.contains(p.right) || p.right.contains(p.left))
    ]),
    part2: std.length([
        true
        for p in pairs
        if p.left.overlaps(p.right)
    ]),
}
