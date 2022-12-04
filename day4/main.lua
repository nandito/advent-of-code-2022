package.path = package.path .. ";../aocutils.lua"
local aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local function get_lists(pair)
    local first_list = {}
    local second_list = {}
    local first_interval_start,
        first_interval_end,
        second_interval_start,
        second_interval_end = string.match(pair, "(%d*)-(%d*),(%d*)-(%d*)")

    for i=first_interval_start, first_interval_end do
        table.insert(first_list, i)
    end
    for i=second_interval_start, second_interval_end do
        table.insert(second_list, i)
    end

    return first_list, second_list
end

local function find(a, tbl)
    for _,a_ in ipairs(tbl) do if a_==a then return true end end
end

local function are_lists_fully_overlap(list1, list2)
    local list1_contains_list2 = true
    for _,section in pairs(list1) do
        if not find(section, list2) then list1_contains_list2 = false end
    end

    local list2_contains_list1 = true
    for _,section in pairs(list2) do
        if not find(section, list1) then list2_contains_list1 = false end
    end

    return list1_contains_list2, list2_contains_list1
end

local full_overlap_counter = 0
for _, line in pairs(lines) do
    local list1, list2 = get_lists(line)
    local l1_in_l2, l2_in_l1 = are_lists_fully_overlap(list1, list2)

    if l1_in_l2 or l2_in_l1 then
        full_overlap_counter = full_overlap_counter + 1
    end
end

print("Part 1: range overlap count: ", full_overlap_counter)
