package.path = package.path .. ";../aocutils.lua"
aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local shape_score_dict = {
    ["A"] = 1, -- rock
    ["B"] = 2, -- paper
    ["C"] = 3, -- scissors
}

local shape_dict = {
    ["X"] = "A",
    ["Y"] = "B",
    ["Z"] = "C",
}

local WIN = 6
local DRAW = 3
local LOSE = 0

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

local scores = {}
local total_score = 0

for _, strategy in pairs(lines) do
    p1, p2_encrypted = strategy:match("(.*) (.*)")
    p2 = shape_dict[p2_encrypted]

    round_score = get_round_score(p1, p2)
    shape_score = shape_score_dict[p2]
    end_score = round_score + shape_score

    table.insert(scores, end_score)
    total_score = total_score + end_score
end

print(total_score)
