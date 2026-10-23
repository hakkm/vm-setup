-- vim.api.nvim_create_user_command(<name>, <cmd>)
-- <name>: must start with uppercase

-- Way 1:
-- vim.api.nvim_create_user_command('Upper', 'echo toupper(<q-args>)', { nargs = 1 })
-- the string 'echo toupper(<q-args>)' is executed as Vimscript
-- -- :command! -nargs=1 Upper echo toupper(<q-args>)
--
-- vim.cmd('Upper hello world') -- prints "HELLO WORLD"-

-- Way 2:
-- vim.api.nvim_create_user_command(
--     'Upper',
--     function(opts)
--         print(string.upper(opts.args))
--     end,
--     { nargs = 1 }
-- )

-- check if not nill then close if nil error
local notify = vim.notify

local function create_source_header_pair()
  -- downside of vim.ui.input (async) if you escape it will not work until reopening nvim
  vim.ui.input({ prompt = "Enter file name: " }, function(filename)
    if filename == '' then
      vim.api.nvim_err_writeln("Invalid filename. Aborting.")
      return
    end

    local cpp_file = filename .. ".cpp"
    local hpp_file = filename .. ".hpp"

    local function create_file(file_path)
      local handle = io.open(file_path, "a")
      if handle == nil then
        vim.api.nvim_err_writeln("Error creating file: " .. file_path)
        return nil
      end
      handle:close()
      return file_path
    end

    local success_cpp = create_file(cpp_file)
    local success_hpp = create_file(hpp_file)

    if success_cpp and success_hpp then
      notify("Files created: " .. cpp_file .. ", " .. hpp_file, vim.log.levels.INFO,
        { title = "CreateSourceHeaderPair" }
      )
    end
  end)
end

vim.api.nvim_create_user_command(
  'CreateSourceHeaderPair',
  create_source_header_pair,
  { nargs = 0 }
)
vim.api.nvim_create_user_command(
  'AddNewPlugin',
  function()
    local plugin_url = vim.fn.input("Enter plugin url: ")

    if plugin_url == '' then
      vim.api.nvim_err_writeln("Invalid plugin url. Aborting.")
      return
    end

    local plugin_list_path = vim.fn.stdpath('config') .. "/lua/plugin_list.lua"

    local plugin_list_file = io.open(plugin_list_path, "r")

    if not plugin_list_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_list_path)
      return
    end

    local lines = {}
    for line in plugin_list_file:lines() do
      table.insert(lines, line)
    end
    plugin_list_file:close()

    -- Replace the last line with the new line
    local new_line = plugin_url
    lines[#lines] = "\t{ '" .. new_line .. "' },"

    -- Add a bracket at the end
    table.insert(lines, "}")

    -- Write the modified content back to the file
    plugin_list_file = io.open(plugin_list_path, "w")
    if not plugin_list_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_list_path)
      return
    end
    for _, line in ipairs(lines) do
      plugin_list_file:write(line, "\n")
    end
    plugin_list_file:close()

    -- vim.inspect("Plugin added: " .. plugin_url)
    notify("Plugin added: " .. plugin_url, vim.log.levels.INFO,
      {
        title = "AddNewPlugin",
      }
    )
  end,
  { nargs = 0 }
)

-- other command that add file to lua/plugins/ and add require to lua/plugins/init.lua
vim.api.nvim_create_user_command(
  'AddNewPluginInFile',
  function()
    local plugin_url = vim.fn.input("Enter plugin url: ")

    if plugin_url == '' then
      vim.api.nvim_err_writeln("Invalid plugin url. Aborting.")
      return
    end

    local plugin_list_path = vim.fn.stdpath('config') .. "/lua/plugin_list.lua"

    local plugin_list_file = io.open(plugin_list_path, "r")

    if not plugin_list_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_list_path)
      return
    end

    local lines = {}
    for line in plugin_list_file:lines() do
      table.insert(lines, line)
    end
    plugin_list_file:close()

    -- Replace the last line with the new line
    local new_line = plugin_url
    lines[#lines] = "\t{ '" .. new_line .. "' },"

    -- Add a bracket at the end
    table.insert(lines, "}")

    -- Write the modified content back to the file
    plugin_list_file = io.open(plugin_list_path, "w")
    if not plugin_list_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_list_path)
      return
    end
    for _, line in ipairs(lines) do
      plugin_list_file:write(line, "\n")
    end
    plugin_list_file:close()

    -- vim.inspect("Plugin added: " .. plugin_url)
    notify("Plugin added: " .. plugin_url .. "\nReopen Neovim to Install it.", vim.log.levels.INFO,
      { title = "AddNewPluginInFile" }
    )

    -- add require to lua/plugins/init.lua
    -- get plugin name
    local plugin_name = string.match(plugin_url, "/(%w*[-_]*%w*)")

    -------------------------------------------- add require to lua/plugins/init.lua
    -- add require to lua/plugins/init.lua
    local plugin_init_path = vim.fn.stdpath('config') .. "/lua/plugins/init.lua"
    local plugin_init_file = io.open(plugin_init_path, "a")
    if not plugin_init_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_init_path)
      return
    end

    -- add require to last line
    local new_line = 'require "plugins.' .. plugin_name .. '"'
    plugin_init_file:write(new_line)
    plugin_init_file:close()

    -- create a file in plugins dir
    local plugin_file_path = vim.fn.stdpath('config') .. "/lua/plugins/" .. plugin_name .. ".lua"
    local plugin_file = io.open(plugin_file_path, "w")
    if not plugin_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_file_path)
      return
    end
    -- close plugin file
    plugin_file:close()
  end,
  { nargs = 0 }
)

-- just the require part
vim.api.nvim_create_user_command(
  'RequirePlugin',

  function()
    -- get plugin url
    local plugin_url = vim.fn.input("Enter plugin url: ")
    if plugin_url == '' then
      vim.api.nvim_err_writeln("Invalid plugin url. Aborting.")
      return
    end


    -- get plugin name rom url
    local plugin_name = string.match(plugin_url, "/(%w*[-_]*%w*)")

    -------------------------------------------- add require to lua/plugins/init.lua
    local plugin_init_path = vim.fn.stdpath('config') .. "/lua/plugins/init.lua"
    local plugin_init_file = io.open(plugin_init_path, "a")
    if not plugin_init_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_init_path)
      return
    end

    -- add require to last line
    local new_line = 'require "plugins.' .. plugin_name .. '"'
    plugin_init_file:write(new_line, "\n")
    plugin_init_file:close()

    -- create a file in plugins dir
    local plugin_file_path = vim.fn.stdpath('config') .. "/lua/plugins/" .. plugin_name .. ".lua"
    local plugin_file = io.open(plugin_file_path, "w")
    if not plugin_file then
      vim.api.nvim_err_writeln("Error opening file: " .. plugin_file_path)
      return
    end
    -- close plugin file
    plugin_file:close()

    notify("Plugin Required: " .. plugin_url, vim.log.levels.INFO,
      { title = "RequirePlugin" }
    )
  end,
  { nargs = 0 }
)

-- LSP Commands: Start, Stop, and Toggle LSP clients using Neovim 0.12+ APIs
vim.api.nvim_create_user_command("LspStart", function(args)
  local cmd = "lsp enable"
  if args.args and args.args ~= "" then
    cmd = cmd .. " " .. args.args
  end
  local ok, err = pcall(vim.cmd, cmd)
  if ok then
    notify(string.format("LSP %s started", args.args ~= "" and args.args or "client(s)"), vim.log.levels.INFO, { title = "LSP Control" })
  else
    notify(err, vim.log.levels.WARN, { title = "LSP Control" })
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("LspStop", function(args)
  local cmd = "lsp disable"
  if args.args and args.args ~= "" then
    cmd = cmd .. " " .. args.args
  end
  local ok, err = pcall(vim.cmd, cmd)
  if ok then
    notify(string.format("LSP %s stopped", args.args ~= "" and args.args or "client(s)"), vim.log.levels.INFO, { title = "LSP Control" })
  else
    notify(err, vim.log.levels.WARN, { title = "LSP Control" })
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("LspToggle", function(args)
  local name = args.args ~= "" and args.args or nil
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = name })
  if #clients > 0 then
    local cmd = "lsp disable"
    if name then
      cmd = cmd .. " " .. name
    end
    local ok, err = pcall(vim.cmd, cmd)
    if ok then
      notify(string.format("LSP %s stopped", name or "client(s)"), vim.log.levels.INFO, { title = "LSP Control" })
    else
      notify(err, vim.log.levels.WARN, { title = "LSP Control" })
    end
  else
    local cmd = "lsp enable"
    if name then
      cmd = cmd .. " " .. name
    end
    local ok, err = pcall(vim.cmd, cmd)
    if ok then
      notify(string.format("LSP %s started", name or "client(s)"), vim.log.levels.INFO, { title = "LSP Control" })
    else
      notify(err, vim.log.levels.WARN, { title = "LSP Control" })
    end
  end
end, { nargs = "?" })
