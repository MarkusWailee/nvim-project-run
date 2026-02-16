


-- ==================== Example ===========================
-- Create a settings_lua file if it does not exist and places a table inside
local M = require("neovim-config")

local function init_settings()
    local f = io.open(M.get_settings_path(), 'r')
    if not f then
        f = io.open(M.get_settings_path(), "w")
        f:write("return " ..vim.inspect(M.opts.default_settings).. "\n")
        f:close()
    end
end

vim.api.nvim_create_user_command("Make", function(args)
    local s = dofile(M.get_settings_path())
    vim.cmd(s.terminal .." "..s.cmd)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Init", function(args)
    vim.fn.mkdir(M.get_folder_path(), "p")
    local f = io.open(M.get_init_path(), 'w')
    if f then
        vim.notify("File \"" .. M.get_init_path() .. "\" Created!")
        f:close()
        init_settings()
        dofile(M.get_init_path())
    end
end, { nargs = "*" })

vim.keymap.set({'n', 'v'}, "<C-b>", function()
    vim.cmd("wa")
    vim.cmd("Make")
end, { desc = "Clear search highlights" })
