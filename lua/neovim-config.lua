local m =
{
    opts =
    {
        init_file =
        {
            enabled = true,
            path = ".neo/init.lua",
        },
        make =
        {
            enabled = true,
            path = ".neo/settings.lua",
            key = "<C-b>",
        },
    }
}

m.setup = function(opts)
    m.opts = vim.tbl_deep_extend("force", m.opts, opts or {})

    -- run the init.lua file
    if m.opts.init_file.enabled then
        if vim.uv.fs_stat(m.opts.init_file.path) then
            dofile(m.opts.init_file.path)
        end
    end

    if m.opts.make.enabled then
        require("neovim-config.make").setup()
    end


    vim.api.nvim_create_user_command("MakeInit", function(args)
        local init_path = m.opts.init_file.path
        if m.opts.init_file.enabled and not vim.uv.fs_stat(init_path) then
            vim.fn.mkdir(vim.fs.dirname(init_path), "p")
            local f = io.open(init_path, "w")
            if f then
                f:write("-- Called when neovim is opened")
                f:close()
                vim.notify(init_path .. " Created")
            end
        end

    end, { nargs = "*" })

end -- End of setup

return m
