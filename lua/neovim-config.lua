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
            path = ".neo/make.lua",
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

end -- End of setup

return m
