local m =
{
    opts =
    {
        folder_name = "nvim-settings",

        default_settings =
        {
            terminal = "ToggleTermExec",
            cmd = "clear & python3 main.py"
        }
    }
}

function m:get_folder_path()
    return m.opts.folder_name
end

function m:get_init_path()
    return m.opts.folder_name .. "/init.lua"
end

function m:get_settings_path()
    return m.opts.folder_name .. "/settings.lua"
end


m.setup = function(opts)
    m.opts = vim.tbl_deep_extend("force", m.opts, opts or {})


    -- run the init.lua file
    local f = io.open(m.get_init_path(), "r")
    if f then
        dofile(m.get_init_path())
        f:close()
    end


    require("neovim-config.plugin")


end -- End of setup

return m
