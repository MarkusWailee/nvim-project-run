--[[
```sh
:Make name
    "Selects and runs the already created command"
:Make name command
    "Selects, creates, and runs the command"
```
]]
vim.api.nvim_create_user_command("Make", function(args)

end, { nargs = "*" })

