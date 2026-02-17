local m =
{
    opts =
    {
        key = "<C-b>",
        file_name = ".neo/init.lua",
    }
}


m.setup = function(opts)
    m.opts = vim.tbl_deep_extend("force", m.opts, opts or {})

    -- run the init.lua file
    local f = io.open(m.opts.file_name, "r")
    if f then
        dofile(m.opts.file_name)
        f:close()
    end


    vim.api.nvim_create_user_command("Init", function(args)
        local parent_dir = vim.fn.fnamemodify(m.opts.file_name, ":h")
        vim.fn.mkdir(parent_dir, "p")  -- automatically creates intermediate dirs
        local f = io.open(m.opts.file_name, 'w')
        if f then
            vim.notify("File \"" .. m.opts.file_name .. "\" Created!")
            f:close()
            dofile(m.opts.file_name)
        end
    end, { nargs = "*" })



end -- End of setup

return m
