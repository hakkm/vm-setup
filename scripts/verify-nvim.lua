-- Silent plugin probes can leave vim.v.errmsg set even when startup succeeded.
-- Check visible startup errors and the actual configuration instead.
local messages = vim.api.nvim_exec2("messages", { output = true }).output
local ok, err = pcall(function()
  assert(not messages:find("Error in ", 1, true), messages)
  assert(not messages:find("Error detected", 1, true), messages)
  local config = require("lazy.core.config")
  assert(config.options.rocks.enabled == false, "Luarocks builds must be disabled")
  for name, plugin in pairs(config.plugins) do
    assert(not plugin.build, "Plugin build hook enabled: " .. name)
  end
  assert(vim.fn.exists(":Lazy") == 2, "Lazy command missing")
  assert(vim.fn.exists(":Copilot") == 2, "Copilot command missing")
  assert(vim.g.mapleader == " ", "Leader key missing")
  assert(vim.o.number and vim.o.relativenumber, "Line number settings missing")
  assert(package.loaded["plugins"], "Plugin configuration did not finish loading")
  assert(package.loaded["ui"], "Theme configuration did not finish loading")
  for _, module in ipairs({ "telescope", "nvim-tree", "lualine", "which-key", "gitsigns", "vscode", "nvim-autopairs", "nvim-surround" }) do
    assert(pcall(require, module), "Required plugin missing: " .. module)
  end
end)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
