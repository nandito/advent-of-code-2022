package.path = package.path .. ";../aocutils.lua"
aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

-- Part 1
function sum_blocks(lines)
    local sums = {}
    local cache = 0

    for i,v in pairs(lines) do
        if (i == #lines) then
            table.insert(sums, cache + v)
            cache = 0
        elseif (v == "") then
            table.insert(sums, cache)
            cache = 0
        else
            cache = cache + v
        end
    end

    return sums
end

blockSums = sum_blocks(lines)
table.sort(blockSums)

print("Biggest carrier's total calories:", blockSums[#blockSums])

-- Part 2
local top3 = 0
for i=0, 2 do
    top3 = top3 + blockSums[#blockSums - i]
end

print("Sum of the top 3 carrier's total calories:", top3)
