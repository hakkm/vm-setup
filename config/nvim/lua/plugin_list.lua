local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  assert(vim.v.shell_error == 0, "Could not clone lazy.nvim")
  vim.fn.system({ "git", "-C", lazypath, "checkout", "306a05526ada86a7b30af95c5cc81ffba93fef97" })
  assert(vim.v.shell_error == 0, "Could not pin lazy.nvim")
end
vim.opt.rtp:prepend(lazypath) -- prepend add to start of runtime table
-- like:
-- vim.opt.rtp.prepend(vim.opt.rtp, lazypath)
local plugins = {
  -- Editing
  { "github/copilot.vim" },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- UI
  { "Mofiqul/vscode.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-lualine/lualine.nvim" },
  { "folke/which-key.nvim", version = "v1.4.2" },
  { "lewis6991/gitsigns.nvim" },
}
-- No plugin may compile native extensions, parsers, or bundled applications.
local function without_builds(spec)
  if type(spec) == "string" then
    return { spec, build = false }
  end
  spec.build = false
  for i, dependency in ipairs(spec.dependencies or {}) do
    spec.dependencies[i] = without_builds(dependency)
  end
  return spec
end
for i, spec in ipairs(plugins) do
  plugins[i] = without_builds(spec)
end
require("lazy").setup(plugins, {
  pkg = { enabled = false },
  rocks = { enabled = false },
  defaults = { lazy = vim.env.VM_SETUP_BOOTSTRAP == "1" },
  install = { missing = vim.env.VM_SETUP_BOOTSTRAP ~= "1" },
})
