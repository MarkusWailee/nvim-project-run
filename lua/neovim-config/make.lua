--[[
```sh
:Make name
    "Selects and runs the already created command"
:MakeAdd
```
]]
local m = {}
local h = require("neovim-config.file_helpers")
local path = require("neovim-config").opts.make.path

-- returns true if command exists, false otherwise

local selected = "selected"

function m.get_table()
    return h.read(path)
end

function m.get_command(name)
    return m.get_table()[name]
end

function m.run_command(name)
    local cmd = m.get_command(name)
    if cmd then
        vim.cmd(cmd)
        return true
    end
    return false
end

function m.run_select_command(name)
    local t = m.get_table()
    local cmd = t[name]
    if cmd then
        vim.cmd(cmd)
        t[selected] = cmd
        t:write()
        return true
    end
    return false
end

function m.select_command(name)
    local t = m.get_table()
    local cmd = t[name]
    if cmd then
        t[selected] = cmd
        return true
    end
    return false
end

function m.create_command(name, command)
    local t = m.get_table()
    t[name] = command
    t:write()
end

function m.remove_command(name)
    local t = m.get_table()
    t[name] = nil
    t:write()
end


function m.setup()
    vim.api.nvim_create_user_command("Make", function(args)
        -- 0 Arguments
        if #args.fargs == 0 then
            if not m.run_command(selected) then
                print("Make command not set")
            end
        elseif #args.fargs == 1 then
            local name = args.fargs[1]
            if not m.run_select_command(name) then
                print("Make command \"" .. name .."\" does not exists")
            end
        end
    end, { nargs = "*" })


    vim.api.nvim_create_user_command("MakeSet", function(args)
        -- 0 Arguments
        if #args.fargs >= 1 then
            local cmd = args.args
            m.create_command(selected, cmd)
            print("Make command set to \""..cmd.."\"")
        else
            print("MakeAdd expect atleast 1 arguments")
        end
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("MakeAdd", function(args)
        -- 0 Arguments
        if #args.fargs > 1 then
            local name = args.fargs[1]
            local cmd = table.concat(args.fargs, " ", 2)
            m.create_command(name, cmd)
            print("Make command \""..name.."\" added")
        else
            print("MakeAdd expect atleast 2 arguments")
        end
    end, { nargs = "*" })


    vim.api.nvim_create_user_command("MakeRemove", function(args)
        -- 0 Arguments
        if #args.fargs == 1 then
            local name = args.fargs[1]
            m.remove_command(name)
            print("Make command \""..name.."\" removed")
        else
            print("MakeRemove expected 1 argument")
        end
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("MakeShow", function(args)
        -- 0 Arguments
        local t = m.get_table()

        local result = {}
        for name, _ in pairs(t) do
            if name ~= selected then
                table.insert(result, name)
            end
        end

        table.sort(result)

        for i,v in ipairs(result) do
            print(i .. ". " ..v)
        end

    end, { nargs = "*" })


end

return m

