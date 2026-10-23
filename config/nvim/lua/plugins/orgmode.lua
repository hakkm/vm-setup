-- Load custom treesitter grammar for org filetype
-- require('orgmode').setup_ts_grammar()

vim.cmd [[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  set nofoldenable                     " Disable folding at startup.
]]

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
  -- highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- disable = { "tex"}, -- no effect
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    -- additional_vim_regex_highlighting = { 'org' },
  },
  ensure_installed = { 'org' }, -- Or run :TSUpdate org
  indent = { enable = true },
}

require('orgmode').setup({
  org_agenda_files = { '~/docs/org/agenda/*', --[[  '~/docs/my-orgs/**/*' ]] },
  org_default_notes_file = '~/docs/org/refile.org',
  org_hide_emphasis_markers = true,
  org_hide_leading_stars = false,
  -- color the stars with diffrente colors depending on the level
  org_level_colors = true,
  org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
  org_todo_keyword_faces = {
    WAITING = ':foreground blue :weight bold',
    DELEGATED = ':background #FFFFFF :slant italic :underline on',
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
  }
})
