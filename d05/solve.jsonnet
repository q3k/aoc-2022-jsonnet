local input = importstr "input.txt";

local recordified = std.strReplace(input, "\n\n", "-");
local parts = std.split(recordified, "-");

local parseInstr(l) = {
    local parts = std.split(l, " "),
    assert std.length(parts) == 6,
    assert parts[0] == "move",
    assert parts[2] == "from",
    assert parts[4] == "to",
    count: std.parseInt(parts[1]),
    from: std.parseInt(parts[3]),
    to: std.parseInt(parts[5]),
};
local addToStack(state, tup) = (
    local i = tup[0];
    local val = tup[1];
    if val == " " then state
    else state {
        stacks+: {
            [std.toString(i)]: state.stacks[std.toString(i)] + [val],
        }
    }
);
local parseStackLine(state, l) = (
    // Bottom line with stack numbering? Parse and create new state with stacks.
    if (std.findSubstr("1", l) != []) then (
        local nstacks = std.length(std.strReplace(l, " ", ""));
        {
            nstacks: nstacks,
            stacks: {
                [std.toString(i)]: [] for i in std.range(1, nstacks)
            }
        }
    ) else (
        // Otherwise, add to stacks.
        local chars = std.stringChars(l);
        local values = [[i+1, chars[1+i*4]] for i in std.range(0, state.nstacks-1)];
        std.foldl(addToStack, values, state)
    )
);
local instructions = [parseInstr(l) for l in std.split(parts[1], "\n") if l != ""];
local stackLines = [l for l in std.split(parts[0], "\n") if l != ""];
local state = std.foldl(parseStackLine, std.reverse(stackLines), []);

{
    part1: {
        local applyMoveOnce(state, move) = state {
            local from = std.toString(move.from),
            local to = std.toString(move.to),
            local fromTop = std.length(state.stacks[from])-1,
            local fromValue = state.stacks[from][fromTop],
            stacks+: {
                [from]: state.stacks[from][:fromTop],
                [to]: state.stacks[to] + [fromValue],
            }
        },
        local applyMoves(state, move) = std.foldl(applyMoveOnce, std.repeat([move], move.count), state),
        local moved = std.foldl(applyMoves, instructions, state),
        result: std.join("", [
            std.stringChars(s)[std.length(s)-1]
            for s in std.objectValues(moved.stacks)
        ]),
   },
   part2: {
        local applyMove(state, move) = state {
            local from = std.toString(move.from),
            local to = std.toString(move.to),
            local fromTop = std.length(state.stacks[from])-move.count,
            local fromValues = state.stacks[from][fromTop:],
            stacks+: {
                [from]: state.stacks[from][:fromTop],
                [to]: state.stacks[to] + fromValues,
            }
        },
        local moved = std.foldl(applyMove, instructions, state),
        result: std.join("", [
            std.stringChars(s)[std.length(s)-1]
            for s in std.objectValues(moved.stacks)
        ]),
   },
}
