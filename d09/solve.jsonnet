// Extremely long execution time for part2.
local input = importstr "input.txt";
local instructions = [
    {
        local parts = std.split(l, " "),
        direction: parts[0],
        count: std.parseInt(parts[1]),
    }
    for l in std.split(input, "\n")
    if l != ""
];

local touching(h, t) = (
    local dx = std.abs(h.x - t.x);
    local dy = std.abs(h.y - t.y);
    dx < 2 && dy < 2
);
local cap(v) = (
    if v > 1 then 1
    else if v < -1 then -1
    else v
);
local rule(lprev, lcur, cur) = (
    if touching(lcur, cur) then cur else (
        local dx = lcur.x - cur.x;
        local dy = lcur.y - cur.y;
        {
            x: cur.x + cap(dx),
            y: cur.y + cap(dy),
        }
    )
);
local step(state, input) = (
    local nh = state.h {
        x: if input == 'R' then state.h.x + 1 else if input == 'L' then state.h.x - 1 else state.h.x,
        y: if input == 'U' then state.h.y + 1 else if input == 'D' then state.h.y - 1 else state.h.y,
    };
    local nt0 = rule(state.h, nh, state.tail[0]);
    // I should generalize this, but I really don't feel like it.
    local tail = if std.length(state.tail) == 1 then [ nt0 ] else (
        local nt1 = rule(state.tail[0], nt0, state.tail[1]);
        local nt2 = rule(state.tail[1], nt1, state.tail[2]);
        local nt3 = rule(state.tail[2], nt2, state.tail[3]);
        local nt4 = rule(state.tail[3], nt3, state.tail[4]);
        local nt5 = rule(state.tail[4], nt4, state.tail[5]);
        local nt6 = rule(state.tail[5], nt5, state.tail[6]);
        local nt7 = rule(state.tail[6], nt6, state.tail[7]);
        local nt8 = rule(state.tail[7], nt7, state.tail[8]);
        [nt0, nt1, nt2, nt3, nt4, nt5, nt6, nt7, nt8]
    );
    state {
        h: nh,
        tail: tail,
        local last = tail[std.length(tail)-1],
        visited: std.set(state.visited + ["%d,%d" % [last.x, last.y]]),
    }
);
local stepn(state, instruction) = std.foldl(step, std.repeat([instruction.direction], instruction.count), state);
{
    part1: {
        local initial = {
            h: { x: 0, y: 0 },
            tail: [ { x: 0, y: 0 } ],
            visited: [],
        },
        sim:: std.foldl(stepn, instructions, initial),
        result: std.length(self.sim.visited),
    },
    part2: {
        local initial = {
            h: { x: 0, y: 0 },
            tail: [ { x: 0, y: 0 } for _ in std.range(1, 9)],
            visited: [],
        },
        sim:: std.foldl(stepn, instructions, initial),
        result: std.length(self.sim.visited),
    },
}
