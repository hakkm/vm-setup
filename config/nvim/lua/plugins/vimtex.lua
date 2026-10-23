-- Enable Vimtex
vim.g.vimtex_enabled = 1

-- Set PDF viewer
vim.g.vimtex_view_method = 'zathura'

-- Set compiler
vim.g.vimtex_compiler_latexmk = {
  options = {
    '-pdf',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}

-- Set spell checking language
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_syntax_conceal_spellcheck = 0
vim.g.vimtex_syntax_conceal = {
  spell = 0,
  math = 0,
  tags = 0,
  urls = 0,
  regions = {},
}

-- Define custom mappings
vim.api.nvim_set_keymap('n', '<leader>xr', ':w <CR>:VimtexCompile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xc', ':VimtexClean<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xv', ':VimtexView<CR>', { noremap = true, silent = true })
