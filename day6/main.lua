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

---Gets the signal marker index
---@param signalMarker number
---@return table
local function getSignal(signalMarker)
    local signalStartIdxs = {}
    for _, chars in pairs(linesAsChars) do
        local potentialSignalChars = List()
        local potentialSignalStartIdx = 1

        for idx, c in pairs(chars) do
            if potentialSignalChars:contains(c) then
                local idxToRemove = potentialSignalChars:index(c)
                potentialSignalChars:chop(1, idxToRemove)
            end
            potentialSignalChars:append(c)

            if #potentialSignalChars == signalMarker then
                potentialSignalStartIdx = idx
                break
            end
        end

        table.insert(signalStartIdxs, potentialSignalStartIdx)
    end
    return signalStartIdxs
end

-- expected for sample.txt
-- 7, 5, 6, 10, 11
-- submitted and approved for input.txt
-- 1578
print("Part 1 - signal start markers at position 4:  " .. table.concat(getSignal(4), ", "))

-- expected for sample.txt
-- 19, 23, 23, 29, 26
-- submitted and approved for input.txt
-- 2178
print("Part 2 - signal start markers at position 14: " .. table.concat(getSignal(14), ", "))
