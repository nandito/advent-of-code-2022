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

-- PART 1

---Checks if list1 contains all of list2's elements and vice versa
---@param list1 table with numbers in a given range
---@param list2 table with numbers in a given range
---@return boolean list1 is fully covered by list2
---@return boolean list2 is fully covered by list1
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

-- PART 2

---Checks if list1 contains any elements which are in list2
---@param list1 table with numbers in a given range
---@param list2 table with numbers in a given range
---@return boolean true if there's at least one common number in the 2 lists
local function are_lists_partially_overlap(list1, list2)
    local has_overlap = false
    for _,section in pairs(list1) do
        if find(section, list2) then has_overlap = true end
    end

    return has_overlap
end

local full_overlap_counter = 0 -- for part 1
local has_overlap_counter = 0  -- for part 2
for _, line in pairs(lines) do
    local list1, list2 = get_lists(line)
    local l1_in_l2, l2_in_l1 = are_lists_fully_overlap(list1, list2)
    local has_partial_overlap = are_lists_partially_overlap(list1, list2)

    if l1_in_l2 or l2_in_l1 then
        full_overlap_counter = full_overlap_counter + 1
    end

    if has_partial_overlap then
        has_overlap_counter = has_overlap_counter + 1
    end
end

print("Part 1: ranges with fully overlap count: ", full_overlap_counter)
print("Part 2: ranges with some  overlap count: ", has_overlap_counter)
