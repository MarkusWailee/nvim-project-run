--[[
```sh
:Make name
    "Selects and runs the already created command"
:MakeAdd
```
]]
local m = {}
local h = require("nvim-quickrun.file_helpers")
local make_path = require("nvim-quickrun").get_make_path()
local key = require("nvim-quickrun").opts.key

-- returns true if command exists, false otherwise

local selected = "current"


function m.get_table()
    return h.read(make_path)
end

function m.is_empty()
    return next(setmetatable(m.get_table(), nil)) == nil
end

function m.get_command(name)
    return m.get_table()[name]
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

function m.select_command(name)
    local t = m.get_table()
    local cmd = t[name]
    if cmd then
        t[selected] = cmd
        t:write()
        return true
    end
    return false
end

function m.menu_list(prompt, callback)
    if m.is_empty() then
        callback(nil)
        return
    end

    local t = m.get_table()
    local key_list = {}
    for name, _ in pairs(t) do
        table.insert(key_list, name)
    end

    local result = false
    table.sort(key_list)
    vim.ui.select(key_list, {
        prompt = prompt,
        format_item = function(item)
            return item .. " -> \"" .. m.get_command(item) .."\""
        end,
    }, function(cmd_name)
        if cmd_name then
            callback(cmd_name)
        end
    end)
end

function m.menu_enter(prompt, callback)
    vim.ui.input({ prompt = prompt }, function(out)
        if out then
            callback(out)
        end
    end)
end

function m.create_command(name, command)
    local t = m.get_table()
    t[name] = command
    t:write()
end

function m.remove_command(name)
    local t = m.get_table()
    if t[name] then
        t[name] = nil
        t:write()
        return true
    end
    return false

end


function m.setup()
    vim.api.nvim_create_user_command("Make", function(args)
        -- 0 Arguments
        if #args.fargs == 0 then
            if not m.run_command(selected) then
                m.menu_list("Use :MakeSet or Choose Commmand", function(name)
                    if name then
                        m.select_command(name)
                    else
                        m.menu_enter("Set Make command: ", function(cmd)
                            m.create_command(selected, cmd)
                        end)
                    end
                end)
            end
        elseif #args.fargs == 1 then
            local name = args.fargs[1]
            if not m.run_command(name) then
                print("Make command \"" .. name .."\" does not exists")
            else
                m.select_command(name)
            end
        end
    end, { nargs = "*" })


    vim.api.nvim_create_user_command("MakeSet", function(args)
        -- 0 Arguments
        if #args.fargs >= 1 then
            local cmd = args.args
            m.create_command(selected, cmd)
            vim.notify("\rMake set to \""..cmd.."\" ")
        else
            m.menu_enter("Enter command: ", function(cmd)
                m.create_command(selected, cmd)
                vim.notify("\rMake set to \""..cmd.."\" ")
            end)
        end
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("MakeAdd", function(args)
        -- 0 Arguments
        if #args.fargs > 1 then
            local name = args.fargs[1]
            local cmd = table.concat(args.fargs, " ", 2)
            m.create_command(name, cmd)
            vim.notify("Make command \""..name.."\" added")
        else
            m.menu_enter("Enter name and command: ", function(out)
                local name, cmd = (out):match("^(%S+)%s*(.*)$")
                m.create_command(name, cmd)
                vim.notify("\rMake command \""..name.."\" added")
            end)
        end
    end, { nargs = "*" })


    vim.api.nvim_create_user_command("MakeRemove", function(args)
        -- 0 Arguments
        m.menu_list("Remove Command", function(name)
            if name then
                m.remove_command(name)
                vim.notify("Removed " ..name)
            else
                vim.notify("Make list is empty.")
            end
        end)
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("MakeList", function(args)
        m.menu_list("Choose Command", function(name)
            if name then
                m.select_command(name)
                vim.notify("Selected " ..name)
            else
                vim.notify("Make list is empty. Use :MakeAdd.")
            end
        end)
    end, { nargs = "*" })

    if key then
        vim.keymap.set(key[1], key[2], function()
            m.run_command(selected)
        end)
    end


end

return m

