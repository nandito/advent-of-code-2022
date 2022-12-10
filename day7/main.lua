package.path = package.path .. ";../aocutils.lua"
local List = require("pl.List")
local Map = require("pl.Map")
local pretty = require("pl.pretty")
local aocutils = require("aocutils")

local file = arg[1] or 'input.txt'
local lines = aocutils.lines_from(file)

local is_cd_up = "$ cd .."
local is_cd_down_pattern = "$ cd (%a+)"
local is_cd_root = "$ cd /"
local is_ls = "$ ls"

local function find_sub_dir(dirs, path)
    local result_dir = nil
    for i,p in pairs(path) do
        dirs:map(function(li) 
            if type(li) == "table" then
                local subfolders = li:keys()

                if subfolders:contains(p) then
                    if #path > i then
                        -- go deeper
                        result_dir = find_sub_dir(li[p], path:slice(-(#path - 1), #path))
                    else
                        -- update
                        result_dir = li[p]
                    end
                end
            end
        end)
    end
    return result_dir
end

local function persist_dir_name(fs, current_path, dir_name)
    if #current_path == 0 then
        fs:append(Map({[dir_name]=List()}))
    else
        local dir_to_update = find_sub_dir(fs, current_path)
        dir_to_update:append(Map({[dir_name] = List()}))
    end
end

local function persist_file_name(fs, current_path, filename)
    if #current_path == 0 then
        fs:append(filename)
    else
        local dir_to_update = find_sub_dir(fs, current_path)
        dir_to_update:append(filename)
    end
end

local fs = List()
local current_path = List()

for _, line in pairs(lines) do
    local cd_to_dir = string.match(line, is_cd_down_pattern)

    if line == is_cd_up then
        current_path:remove(#current_path)
    elseif line == is_cd_root then
        current_path:clear()
    elseif line == is_ls then
        -- print("ls", line)
    elseif cd_to_dir then
        current_path:append(cd_to_dir)
    else
        local dir_name = string.match(line, "^dir (%a+)")
        if dir_name then
            persist_dir_name(fs, current_path, dir_name)
        else
            persist_file_name(fs, current_path, line)
        end
    end
end

local LIMIT = 100000

local dir_sizes = List()
local cache = List()

local function calc(elements)
    local dir_total = 0

    for elem in elements:iter() do
        local size = 0
        if type(elem) == "string" then
            size = string.match(elem, "(%d+)")
            if size == nil then
                size = calc(elements[elem])
            end
        else
            size = calc(elem)
        end
        dir_total = dir_total + size
    end
    if elements.index and dir_total > 0 then
        dir_sizes:append(dir_total)
        if dir_total <= LIMIT then
            cache:append(dir_total)
        end
    end
    return dir_total
end

calc(fs)

pretty.dump(fs)
local sizes_below_limit = cache:reduce(function(a,b)
    return a+b
end)

-- print(dir_sizes)
print(cache)
print(sizes_below_limit)
