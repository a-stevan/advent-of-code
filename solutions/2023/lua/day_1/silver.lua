dofile("../../../../templates/lua/read.lua")

local input_filename = arg[1]
assert(input_filename ~= nil, "expected input filename as first positional argument")
assert(file_exists(input_filename), "file not found: `" .. input_filename .. '`')

local input = lines_from(input_filename)
local total = 0

for _, v in pairs(input) do
    local digits = {}
    local s, m
    s = 0

    while s do
        s, _, m = string.find(v, "(%d)", s + 1)
        digits[#digits + 1] = m
    end
    total = total + tonumber(digits[1] .. digits[#digits])
end

print(total)
