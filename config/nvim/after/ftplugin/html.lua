if vim.fn.expand('%:p:h'):match("templates") then
  -- lsp is running before the start of this file
  vim.bo.filetype = "htmldjango"
end
