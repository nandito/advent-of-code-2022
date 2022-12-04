local aocutils = {}

-- see if the file exists
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

---Get all lines from a file
---@param file string filename
---@return table with one line per item
aocutils.lines_from = function (file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

---Prints all line numbers and their contents
---@param lines table
aocutils.print_lines = function (lines)
    for k,v in pairs(lines) do
        print('line[' .. k .. ']', v)
    end
end

---Checks if the given parameter can be found in the given table.
---@param a any the parameter to find
---@param tbl table the table where we search
---@return boolean true if `a` is in the table, false if it is not there
aocutils.find = function (a, tbl)
    for _,a_ in ipairs(tbl) do if a_==a then return true end end
end

return aocutils
