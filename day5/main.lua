package.path = package.path .. ";../aocutils.lua"
local List = require("pl.List")
local Map = require("pl.Map")
local aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local stack_elements = {}
local stacks = {}
local moves = List()

local sample_stack_index_pattern = "(%d)%s*(%d)%s*(%d)"
local sample_stack_line_pattern = "[^%d%s%l]"
local move_line_pattern = "move (%d+) from (%d+) to (%d+)"

local function get_stack_values(line)
        local temp = {}
        local result = {}
        for str in string.gmatch(line, "(.)") do
            table.insert(temp, str)
        end

        table.insert(temp, " ") -- add trailing space

        for i,v in pairs(temp) do
            if i % 4 == 0 then
                table.insert(result, temp[i-2] == " " and nil or temp[i-2])
            end
        end
        return result
end

for _, line in pairs(lines) do
    local is_stack_index_line = string.match(line, sample_stack_index_pattern)
    local is_stack_line = string.match(line, sample_stack_line_pattern)
    -- print(line)
    local is_move_line = string.match(line,move_line_pattern)

    if is_stack_index_line ~= nil then
        for v in string.gmatch(line, "%d") do
            table.insert(stacks, v)
        end
    end

    if is_stack_line ~= nil then
        local s = get_stack_values(line)
        table.insert(stack_elements, s)
    end

    if is_move_line ~=nil then
        local ls = List()
        for v in string.gmatch(line, "%d+") do
            ls:append(v)
        end
        moves:append(ls)
    end
end

local stack_state = Map{}
local stack_state_copy = Map{}

for _, se in pairs(stack_elements) do
    for ii, se2 in pairs(se) do
        local existingList = stack_state:get(""..ii)
        if se2 == " " then 
        elseif existingList then
            local updatedList =  existingList:insert(1,se2)
            stack_state:set(""..ii,updatedList)
            stack_state_copy:set(""..ii, updatedList:clone())
        else
            local ls = List()
            ls:append(se2)
            stack_state:set(""..ii, ls)
            stack_state_copy:set(""..ii, ls:clone())
        end
    end
end

local function getTops(stks, state)
    local topElements = "" 
    for key,_  in pairs(stks) do
        local stk = state:get(""..key)
        topElements = topElements .. stk[#stk]
    end
    return topElements
end

-- PART 1
-- make the moves
for move in moves:iter() do
    local count = move[1]
    local from = move[2]
    local to = move[3]

    for i=1, count do
        local sourceCol = stack_state:get(""..from)
        local elementToMove = sourceCol[#sourceCol]
        local targetCol = stack_state:get(""..to)
        stack_state:set(""..to, targetCol:append(elementToMove))
        stack_state:set(""..from, sourceCol:remove(#sourceCol))
    end
end

-- PART 2
-- make the moves
for move in moves:iter() do
    local count = move[1]
    local from = move[2]
    local to = move[3]

    local sourceCol = stack_state_copy:get(""..from)

    local elementsToMove = sourceCol:slice(-count)
    local targetCol = stack_state_copy:get(""..to)
    stack_state_copy:set(""..to, targetCol:extend(elementsToMove))
    stack_state_copy:set(""..from, sourceCol:slice(1, #sourceCol-count))
end

print("Part 1 - top elements:", getTops(stacks, stack_state))
print("Part 2 - top elements:", getTops(stacks, stack_state_copy))
