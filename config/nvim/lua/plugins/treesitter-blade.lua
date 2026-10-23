local parsers = require "nvim-treesitter.parsers"
local parser_config = parsers.get_parser_configs and parsers.get_parser_configs() or parsers
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade"
}

-- Set the *.blade.php file to be filetype of blade
vim.cmd [[
  augroup BladeFiltypeRelated
    au BufNewFile,BufRead *.blade.php set ft=blade
  augroup END
]]
