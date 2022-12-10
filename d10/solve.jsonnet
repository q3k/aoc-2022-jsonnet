local input = importstr "input.txt";
local lines = [
    local parts = std.split(l, " ");
    [
        parts[0],
        if parts[0] == "noop" then null else std.parseInt(parts[1])
    ]
    for l in std.split(input, "\n")
    if l != ""
];

local ucycles = std.flatMap(function(el) (
    if el[0] == 'addx' then [
        [ "noop", null ],
        el
    ] else [ el ]
), lines);
local execution = std.foldl(function(state, el) (
    local newstate = (
        if el[0] == "noop" then state
        else if el[0] == "addx" then state {
            x: state.x + el[1]
        }
    );
    newstate {
        log: newstate.log + [ newstate.x ],
    }
), ucycles, { x: 1, log: [] });

{
    part1: {
        result: std.foldl(function(a,b) a+b, [execution.log[i-2]*i for i in [20, 60, 100, 140, 180, 220]], 0),
    },
    part2: {
        local log = [1] + execution.log,
        local render(offset) = std.join('', [
            local middle = log[i] + offset;
            local visible = (i == middle -1) || (i == middle) || (i == middle+1);
            if visible then '#' else ' '
            for i in std.range(offset,offset + 39)
        ]),
        result: [
            render(0),
            render(40),
            render(80),
            render(120),
            render(160),
            render(200),
        ],
    },
}
