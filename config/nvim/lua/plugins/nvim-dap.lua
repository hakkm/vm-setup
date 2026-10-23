local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("Failed to load dap")
  return
end

-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "codelldb",
--     request = "launch",
--     -- program = function()
--     --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     -- end,
--     -- cwd = '${workspaceFolder}',
--     -- stopOnEntry = true,
--     -- args = {},
--     -- runInTerminal = false,
--   },
-- }


-- icons
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
-- 🔴 🟥

-- dapui
local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
  vim.notify("Failed to load dapui")
  return
end

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- mason-nvim-dap
local status_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if not status_ok then
  vim.notify("Failed to load mason-nvim-dap")
  return
end

mason_nvim_dap.setup({
  auto_install = true,
})


dap.configurations.cpp = {
  {
    name = "lldb",
    type = "cpp",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    externalTerminal = false,
    stopOnEntry = false,
    args = {}
  },
}

dap.adapters.cpp = {
  type = 'executable',
  attach = {
    pidProperty = "pid",
    pidSelect = "ask"
  },
  command = 'lldb-vscode', -- my binary was called 'lldb-vscode-11'
  env = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
  },
  name = "lldb"
}
