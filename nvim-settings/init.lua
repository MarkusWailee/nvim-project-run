-- Runs when neovim is opened

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "main.py",
    callback = function()
        vim.fn.jobstart(
            { "python3", "main.py" },
            { detach = true }
        )
    end,
})



-- ==================== Example ===========================
-- Create a settings_lua file if it does not exist and places a table inside
local M = require("neovim-config")
local settings_lua = M.get_folder_path() .. "/settings.lua"
local f = io.open(settings_lua, 'r')
if not f then
    f = io.open(settings_lua, "w")
    local settings_lua = { terminal = "ToggleTermExec", cmd = "clear & python3 main.py" }
    f:write("return " ..vim.inspect(settings_lua).. "\n")
    f:close()
end

-- Creates a Make command that uses the settings_lua file to run a vim command
vim.api.nvim_create_user_command("Make", function(args)
    local s = dofile(settings_lua)
    vim.cmd(s.terminal .." "..s.cmd)
end, { nargs = "*" })

-- Creates a keybind to Make
vim.keymap.set({'n', 'v'}, "<C-b>", function()
    vim.cmd("wa")
    vim.cmd("Make")
end, { desc = "Clear search highlights" })
-- ==========================================================
