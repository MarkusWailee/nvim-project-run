


local h = require("neovim-config.file_helpers")

local s = h.read(".neo/settings.lua")
s.cmd = 1234
s:write()








