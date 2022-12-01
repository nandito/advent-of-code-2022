local aocutils = {}

-- see if the file exists
function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
aocutils.lines_from = function (file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

-- print all line numbers and their contents
aocutils.print_lines = function (lines)
    for k,v in pairs(lines) do
        print('line[' .. k .. ']', v)
    end
end

return aocutils
