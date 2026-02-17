local m = {}
-- vim.uv.fs_stat(path) -- test if file exists

local Writable = {}

--[[
# Writes back to the read file
]]
function Writable:write()
    local f = io.open(getmetatable(self).path, "w")
    if f then
        setmetatable(self, nil)
        f:write("return " ..vim.inspect(self, {indent = "    "}) .."\n")
        f:close()
        return true
    end
    return false
end

--[[
# Returns a lua object from path
]]
function m.read(path)
    local result = {}
    if vim.uv.fs_stat(path) then
        result = dofile(path)
    end

    return setmetatable(result, {
        __index = Writable,
        path = path
    })
end

--[[
# Writes a lua object into a file

project/init.lua ↓
```lua
t = w.read(settings.lua)
t.a = "a"
t.b = "b"
t:write("settings.lua")
```

project/settings.lua ↓
```lua
return {
    a = "a",
    b = "b"
}
```
]]


return m




