local m =
{
    opts =
    {
        folder_name = "nvim-settings"
    }
}

function m:get_folder_path()
    return m.opts.folder_name
end

function m:get_init_path()
    return m.opts.folder_name .. "/init.lua"
end



m.setup = function(opts)
    m.opts = vim.tbl_deep_extend("force", m.opts, opts or {})

    local init_lua = m.opts.folder_name .. "/init.lua"

    -- run the init.lua file
    local f = io.open(init_lua, "r")
    if f then
        dofile(init_lua)
        f:close()
    end

    -- Initialize the settings folder
    vim.api.nvim_create_user_command("Init", function(args)
        vim.fn.mkdir(m.opts.folder_name, "p")
        local f = io.open(init_lua, 'w')
        if f then
            f:write(require("neovim-config.init_example_code"))
            vim.notify("File \"" .. init_lua .. "\" Created!")
            f:close()
            dofile(init_lua)
        end
    end, { nargs = "*" })

end -- End of setup

return m
