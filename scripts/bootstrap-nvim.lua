-- Restore the lockfile before loading config modules that require installed plugins.
vim.env.VM_SETUP_BOOTSTRAP = "1"
vim.opt.rtp:prepend(vim.fn.stdpath("config"))
require("plugin_list")
-- Installing missing plugins normally rewrites the lock with any existing
-- checkout versions. Keep the reviewed lock intact throughout this bootstrap.
local lock = require("lazy.manage.lock")
lock.load()
lock.update = function() end
local function verify()
  local failed = false
  for name, plugin in pairs(require("lazy.core.config").plugins) do
    if not plugin._.installed then
      io.stderr:write("Plugin not installed: " .. name .. "\n")
      failed = true
    end
    for _, task in ipairs(plugin._.tasks or {}) do
      if task:has_errors() then
        io.stderr:write(name .. ": " .. task:output(vim.log.levels.ERROR) .. "\n")
        failed = true
      end
    end
  end
  if failed then
    vim.cmd("cquit 1")
  end
end
require("lazy").install({ wait = true, lockfile = true, show = false })
verify()
require("lazy").restore({ wait = true, show = false })
verify()
local git = require("lazy.manage.git")
for name, plugin in pairs(require("lazy.core.config").plugins) do
  local expected = lock.lock[name]
  local actual = git.info(plugin.dir)
  if expected and (not actual or actual.commit ~= expected.commit) then
    io.stderr:write("Plugin differs from lockfile: " .. name .. "\n")
    vim.cmd("cquit 1")
  end
end
