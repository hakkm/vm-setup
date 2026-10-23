vim.keymap.set('i', '<C-L>', '<C-R>=copilot#Accept("")<CR>', { desc = "Use copilot", remap = false })
-- fix tab add new line instead of indent in insert mode
vim.g.copilot_filetypes = {
  ["*"] = true,
  ["javascript"] = true,
  ["lua"] = true,
  ["c"] = true,
  ["c++"] = true,
  ["python"] = true,
  ["markdown"] = true,
  ["zsh"] = true,
}
vim.g.copilot_no_tab_map = true
