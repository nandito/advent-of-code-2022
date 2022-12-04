package.path = package.path .. ";../aocutils.lua"
local aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- returns a table with the given 2 tables' common elements
local function get_commons(a, b)
   local ret = {}
   for _,a_ in ipairs(a) do
       if aocutils.find(a_,b) then
           table.insert(ret, a_)
       end
   end
   return ret
end

-- PART 1

-- splits a rucksack to 2 compartments and return each
-- compartments as a table of characters
local function get_compartments(rucksack)
    local first = {}
    local second = {}
    local i = 1
    for c in string.gmatch(rucksack, "(.)") do
        if i <= (#rucksack / 2) then
            table.insert(first, c)
        else
            table.insert(second, c)
        end
        i = i + 1
    end
    return first, second
end

local total_priority = 0
for _, rucksack in pairs(lines) do
    local first, second = get_compartments(rucksack)
    local common = get_commons(first,second)
    local priority = string.find(ALPHABET, common[1])
    total_priority = total_priority + priority
end

print("Part 1: total priority:          ", total_priority)

-- PART 2

-- returns a table of characters from a line of characters (rucksack)
local function rucksack_to_table(rucksack)
    local chars = {}
    for c in string.gmatch(rucksack, "(.)") do
        table.insert(chars, c)
    end
    return chars
end

-- move every 3 lines into 1 group
local groups = {}
local temp_row = {}
for i, rucksack in pairs(lines) do
    table.insert(temp_row, rucksack_to_table(rucksack))

    if i % 3 == 0 then
        table.insert(groups, temp_row)
        temp_row = {}
    end
end

local total_priority_of_groups = 0
for _, group in pairs(groups) do
    -- each group has 3 rucksacks
    local rucksack1 = group[1]
    local rucksack2 = group[2]
    local rucksack3 = group[3]

    local common_in_first_2_groups = get_commons(rucksack1, rucksack2)
    local common_in_all = get_commons(common_in_first_2_groups, rucksack3)
    local priority = string.find(ALPHABET, common_in_all[1])
    total_priority_of_groups = total_priority_of_groups + priority
end

print("Part 2: total priority of groups:", total_priority_of_groups)
