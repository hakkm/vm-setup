local status_ok, hop = pcall(require, "hop")
if not status_ok then
  vim.notify("hop don't work")
  return
end

hop.setup {
  quit_key = '<SPC>',
  case_insensitive = false,
}

local directions = require('hop.hint').HintDirection
-- local status_ok, directions = pcall(require, "hop.hint.HintDirection")
-- if not status_ok then
--   vim.notify("lsp-zero don't work")
--   return
-- end

local opts = { noremap = true, silent = true, remap = true }
local keymap = vim.keymap.set
-- keymap('i', '<C-H>', '<C-w>', opts)
-- require 'hop'.hint_anywhere()
keymap('n', '<leader>j', function()
  hop.hint_char1()
end, opts)
keymap('n', '<c-y>', function()
  hop.hint_char1()
end, opts)
keymap('i', '<c-y>', function()
  hop.hint_char1()
end, opts)
keymap('n', 's', function()
  hop.hint_char1()
end, opts)

-- Reimplement t / T
keymap('n', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, opts)
keymap('n', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, opts)
-- Reimplement t / T
keymap('n', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, opts)
keymap('n', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, opts)
