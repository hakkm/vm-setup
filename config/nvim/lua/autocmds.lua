-- cours about autocmd
-- syntax: autocmd <event> <pattern> <command>
-- list of pattens: .txt,*.py,...
-- lsit of events: FileType,BufWinEnter,...
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup term
    autocmd!
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal norelativenumber
  augroup end

" use this command to disable folding =:set nofoldenable=
  augroup Folding
    autocmd!
    autocmd BufWinLeave * if &buftype ==# '' && expand('%') !=# '' | silent! mkview | endif
    autocmd BufWinEnter * if &buftype ==# '' && expand('%') !=# '' | silent! loadview | endif
  augroup end

" remove status line for NvimTree
  augroup NvimTree
    autocmd!
    autocmd BufWinEnter NvimTree setlocal statusline=%!DisableST()
  augroup end

  augroup _help
    autocmd!
    autocmd BufWinEnter help setlocal scrolloff=0
  augroup end

  " augroup php_html
  "   autocmd!
  "   autocmd BufRead,BufNewFile *.php set ft=php.html
  " augroup end
]]

-- local folding_group = vim.api.nvim_create_augroup("Folding", {clear = true})
-- vim.api.nvim_create_autocmd("BufWinLeave", {
--   pattern = {"*"},
--   group = folding_group,
--   callback = function()
--     vim.cmd("silent! mkview")
--   end,
-- }
-- )
--
-- vim.api.nvim_create_autocmd("BufWinEnter",{
--   pattern = {"*"},
--   group = folding_group,
--   callback = function()
--     vim.cmd("silent! loadview")
--     -- vim.cmd("loadview")
--   end,
-- }
-- )

-- when creating the group
-- whether we want to clear it first
--- clear: means clearing the processes running
