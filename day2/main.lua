package.path = package.path .. ";../aocutils.lua"
aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local WIN = 6
local DRAW = 3
local LOSE = 0

local shape_score_dict = {
    ["A"] = 1, -- rock
    ["B"] = 2, -- paper
    ["C"] = 3, -- scissors
}

-- meaning of X, Y, Z in the 1st challenge
local shape_dict = {
    ["X"] = "A",
    ["Y"] = "B",
    ["Z"] = "C",
}

-- meaning of X, Y, Z in the 2nd challenge
local expected_end_dict = {
    ["X"] = LOSE,
    ["Y"] = DRAW,
    ["Z"] = WIN,
}

-- returns the result of the match between p1 and p2
-- it is from p2's POV
function get_round_score(p1, p2) 
    if p1 == p2 then return DRAW end

    if p1 == "A" then
        if p2 == "B" then return WIN
        else return LOSE end
    end

    if p1 == "B" then
        if p2 == "C" then return WIN
        else return LOSE end
    end

    if p1 == "C" then
        if p2 == "A" then return WIN
        else return LOSE end
    end
end

-- returns the expected shape to get the expected_end against p1
function get_expected_shape(p1, expected_end)
    if expected_end == DRAW then return p1 end

    if expected_end == WIN then
        if p1 == "A" then return "B"
        elseif p1 == "B" then return "C"
        else return "A"
        end
    end

    if expected_end == LOSE then
        if p1 == "A" then return "C"
        elseif p1 == "B" then return "A"
        else return "B"
        end
    end
end

local total_score = 0
local total_score2 = 0

for _, strategy in pairs(lines) do
    -- part1
    p1, second_col = strategy:match("(.*) (.*)") -- player1
    p2 = shape_dict[second_col]                  -- player2

    round_score = get_round_score(p1, p2)
    shape_score = shape_score_dict[p2]
    end_score = round_score + shape_score

    total_score = total_score + end_score

    -- part2
    expected_end = expected_end_dict[second_col]
    expected_shape = get_expected_shape(p1, expected_end)
    shape_score2 = shape_score_dict[expected_shape]
    end_score2 = expected_end + shape_score2

    total_score2 = total_score2 + end_score2
end

print("Part 1: Score if 2nd col means player2's choice:    ", total_score)
print("Part 2: Score if 2nd col means the expected outcome:", total_score2)
