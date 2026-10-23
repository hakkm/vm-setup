local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if status_ok then
  configs.setup({
    -- automatically install parsers if missing
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gss", -- set to `false` to disable one of the mappings
        node_incremental = "gsi",
        scope_incremental = "gsc",
        node_decremental = "gsd",
      },
    },
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          -- You can also use captures from other query groups like `locals.scm`
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ['@parameter.outer'] = 'V', -- charwise
          ['@function.outer'] = 'V',  -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
          ['@class.outer'] = 'V', -- blockwise
          ['@function.inner'] = 'V',
        },
        include_surrounding_whitespace = false,
      },
    },
  })
else
  -- Neovim 0.12+ native Treesitter configuration
  -- Highlighting is built-in and enabled by default.

  -- Incremental selection keymaps (mimicking legacy nvim-treesitter mappings using native motions)
  vim.keymap.set("n", "gss", "v", { desc = "TS: Init selection" })
  vim.keymap.set("x", "gsi", "an", { desc = "TS: Node incremental" })
  vim.keymap.set("x", "gsd", "in", { desc = "TS: Node decremental" })
  vim.keymap.set("x", "gsc", "]n", { desc = "TS: Scope incremental" })

  -- Setup textobjects (configured separately in the main branch of nvim-treesitter-textobjects)
  local ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
  if ok then
    ts_textobjects.setup({
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ['@parameter.outer'] = 'V',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
          ['@function.inner'] = 'V',
        },
        include_surrounding_whitespace = false,
      },
    })
  end
end
