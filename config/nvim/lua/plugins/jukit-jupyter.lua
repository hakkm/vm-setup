vim.g.jukit_pdf_viewer = 'zathura'

vim.cmd [[
let g:jukit_mappings_ext_enabled = ["py", "ipynb"]
nnoremap <C-<cr>> :call jukit#send#line()<cr>
]]


vim.cmd [[
  augroup _jukit
    autocmd!
    autocmd FileType python nnoremap <buffer> <cr> :call jukit#send#line()<cr>
  augroup end
]]


-- -- convert it to lua
-- vim.api.nvim_set_keymap('n', '<leader>np', ':call jukit#convert#notebook_convert("jupyter-notebook")<cr>',
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>ht', ':call jukit#convert#save_nb_to_file(0,1,"html")<cr>',
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rht', ':call jukit#convert#save_nb_to_file(1,1,"html")<cr>',
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>pd', ':call jukit#convert#save_nb_to_file(0,1,"pdf")<cr>',
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>rpd', ':call jukit#convert#save_nb_to_file(1,1,"pdf")<cr>',
--   { noremap = true, silent = true })
