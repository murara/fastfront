-- Copyright (C) by Kwanhur Huang


local modulename = 'restyPurge'
local _M = {}
local mt = { __index = _M }
_M._VERSION = '0.0.1'
_M._NAME = modulename

local COLON = ":"
local SLASH = "/"

local prefix = ngx.config.prefix
local md5 = ngx.md5

local setmetatable = setmetatable
local ipairs = ipairs
local tonumber = tonumber

local open = io.open
local remove = os.remove
local str_find = string.find
local str_sub = string.sub
local str_len = string.len
local tbl_insert = table.insert

_M.new = function(self, path, levels)
    self.path = path or prefix
    self.levels = levels
    return setmetatable(self, mt)
end

local exist = function(filename)
    local f, err = open(filename)
    if f == nil then
        return false
    else
        f:close()
        return true
    end
end

local expand = function(delimiter, levels)
    if #levels == 1 then
        return { levels }
    end

    local ret = {}
    local start = 0
    while true do
        local index = str_find(levels, delimiter, start, true)
        if index ~= nil then
            -- revert level sequence
            tbl_insert(ret, str_sub(levels, start, index - 1))
            start = index + 1
        else
            tbl_insert(ret, str_sub(levels, start))
            break
        end
    end
    return ret
end

-- /path/to/cache/c/29/b7f54b2df7773722d382f4809d65029c
local cache_filename = function(path, levels, key)
    local md5sum = md5(key)
    levels = expand(COLON, levels)
    local filename = ""

    local index = str_len(md5sum)
    for _, v in ipairs(levels) do
        local length = tonumber(v) -- directory name length == how many charaters
        index = index - length
        filename = filename .. str_sub(md5sum, index + 1, index + length) .. SLASH
    end
    if str_sub(path, -1) ~= SLASH then
        path = path .. SLASH
    end
    filename = path .. filename .. md5sum
    return filename
end

_M.purge = function(self, key)
    if not key then
        return false, "key not specified"
    end

    local filename = cache_filename(self.path, self.levels, key)
    if exist(filename) then
        remove(filename)
        return true, nil
    else
        return false, 'file not found'
    end
end

return _M
