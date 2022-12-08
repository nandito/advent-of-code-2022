package.path = package.path .. ";../aocutils.lua"
local List = require("pl.List")
local aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local linesAsChars = {}
for _, line in pairs(lines) do
   local chars = {}
   for c in line:gmatch("(.)") do
       table.insert(chars, c)
   end
   table.insert(linesAsChars, chars)
end

-- PART 1
for _, chars in pairs(linesAsChars) do
    local potentialSignalChars = List()
    local potentialSignalStartIdx = 1

    for idx, c in pairs(chars) do
        if potentialSignalChars:contains(c) then
            local idxToRemove = potentialSignalChars:index(c)
            potentialSignalChars:chop(1, idxToRemove)
        end
        potentialSignalChars:append(c)

        if #potentialSignalChars == 4 then
            potentialSignalStartIdx = idx
            break
        end
    end

    print(potentialSignalChars)
    print(potentialSignalStartIdx)
end
