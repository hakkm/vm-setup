local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded",       -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },                                             -- min and max height of the columns
    width = { min = 20, max = 50 },                                             -- min and max width of the columns
    spacing = 3,                                                                -- spacing between columns
    align = "left",                                                             -- align columns left, center or right
  },
  ignore_missing = true,                                                        -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                             -- show help message on the command line when the popup is visible
  triggers = "auto",                                                            -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {
  -- ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
  ["b"] = {
    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    "Buffers",
  },
  -- ["b"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Buffers" },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>q!<CR>", "Quit" },
  -- ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  ["f"] = {
    "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    "Find files",
  },
  ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  ["<leader>f"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
  ["M"] = { "<cmd>MarkdownPreview<cr>", "Markdown preview" },
  ["R"] = { "<cmd>w <CR>:RunFile toggleterm<CR>", "Runner" },
  ["rrr"] = { "<cmd>w <CR>:RunFile toggleterm<CR>", "Run file" },
  ["rmd"] = { "<cmd>w <CR>:make<CR>", "make" },
  ["rmf"] = { "<cmd>make file='%:t:r'<CR>", "make current file" },
  ["rrf"] = { "<cmd>make run file='%:t:r'<CR>", "make current file" },
  ["red"] = { "<cmd>w <CR>:make run<CR>", "Execute (make run)" },

  -- icon picker
  -- ["i"] = { "<cmd>IconPickerInsert<cr>", "Icon Picker" },
  -- ["y"] = { "<cmd>IconPickerYank<cr>", "Icon Picker Yank" },

  r = {
    name = "Run",
    r = { "<cmd>w <CR>:RunFile toggleterm<CR>", "Run file with code runner" },
    m = {
      name = "Make",
      d = { "<cmd>w <CR>:make<CR>", "make" },
      f = { "<cmd>make file='%:t:r'<CR>", "make current file" },
    },
    e = {
      name = "Execute (make run)",
      d = { "<cmd>w <CR>:make run<CR>", "Execute (make run)" },
      f = { "<cmd>make run file='%:t:r'<CR>", "make current file" },
    }
    -- f = {
    --   name = "File",
    --   r = { "<cmd>make run file='%:t:r'<CR>", "make current file" },
    --   m = { "<cmd>make file='%:t:r'<CR>", "make current file" },
    -- },
    -- d = {
    --   name = "Directory",
    --   r = { "<cmd>make run dir='%:p:h'<CR>", "make current directory" },
    --   m = { "<cmd>make dir='%:p:h'<CR>", "make current directory" },
    -- },
  },

  u = {
    c = { "<cmd>Telescope colorscheme<cr>", "ColorScheme" },
    i = { "<cmd>Nerdy<cr>", "Insert Icon" },
    z = { "<cmd>lua require('zen-mode').toggle()<cr>", "Zen Mode" },
    -- no relative numbers
    n = { "<cmd>setlocal norelativenumber!<cr>", "No Relative Numbers" },
    t = {
      name = "TailwindCss",
      s = { "<cmd>TailwindSort<cr>", "Sort Class" },
    },
  },

  c = {
    name = "Codi",
    a = { "<cmd>Codi<cr>", "Activate Codi" },
    d = { "<cmd>Codi!<cr>", "Deactivate Codi" },
    n = { "<cmd>CodiNew<cr>", "New Codi" },
    s = { "<cmd>CodiSelect<cr>", "Select Codi" },
    e = { "<cmd>CodiExpand<cr>", "Expand Codi" },
  },

  h = {
    name = "Harpoon/high",
    n = { "<cmd>nohlsearch<cr>", "No Highlight" },
    h = { "<cmd>Telescope harpoon marks<cr>", "Harpoon" },
    a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add File" },
  },

  p = {
    name = "Plugin",
    a = { "<cmd>AddNewPlugin<cr>", "Add Plugin" },
    f = { "<cmd>AddNewPluginInFile<cr>", "Add Plugin + Require" },
    r = { "<cmd>RequirePlugin<cr>", "Require Plugin" },
  },

  g = {
    name = "Git",
    f = { ":Git<CR>", "Fugitive" },
    g = { "<cmd>lua lazygit_toggle()<CR>", "Lazygit" }, -- see toggle_term
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Diff",
    },
  },

  l = {
    name = "LSP",
    c = {
      name = "Copilot",
      d = { "<cmd>Copilot disable<cr>", "Disable copilot" },
      e = { "<cmd>Copilot enable<cr>", "Enable copilot" },
      s = { "<cmd>Copilot status<cr>", "Status copilot" },
      p = { "<cmd>Copilot panel<cr>", "panel copilot" },
    },
    F = {
      name = "Folders",
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Workspace [A]dd Folder" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Workspace [R]emove Folder" },
    },
    d = {
      name = "Document",
      d = {
        "<cmd>Trouble diagnostics<cr>",
        "Document Diagnostics",
      },
      f = { "<cmd>Telescope lsp_document_symbols<cr>", "[F]zf Symbols" },
      s = { "<cmd>SymbolsOutline<cr>", "[S]ymbols Outline" },
    },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    -- w = {
    --   "<cmd>TroubleToggle workspace_diagnostics<cr>",
    --   "Workspace Diagnostics",
    -- },
    -- f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    j = {
      "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    -- q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
    q = {
      "<cmd>Trouble diagnostics<cr>",
      "Document Diagnostics",
    },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>LspStart<cr>", "Start LSP" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    t = { "<cmd>LspToggle<cr>", "Toggle LSP" },
    x = { "<cmd>LspStop<cr>", "Stop LSP" },
  },
  s = {
    name = "Search/Sessions",
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    e = { "<cmd>lua require('luasnip.loaders').edit_snippet_files()<cr>", "Edit Snippets" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    o = { "<cmd>Telescope oldfiles<cr>", "Open Recent/Old Files" }, -- old just for speed of thought
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    s = { ":SessionSave<CR>", "Save Session" },
    r = { ":SessionRestore<CR>", "Restore Session" },
    l = { ":lua require('auto - session.session - lens ').search_session()<CR>", "List Sessions" },
  },

  T = {
    name = "Terminal",
    n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },
  x = {
    name = "Latex",
    r = { ":w <CR>:VimtexCompile<CR>", "Run / Compile" },
    c = { ":VimtexClean<CR>", "Clean" },
    v = { ":VimtexView<CR>", "View" },
  },
  d = {
    name = "DAP",
    c = { ":DapContinue<CR>", "Continue" },
    b = { ":DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
    r = { ":lua require('dapui').open({reset = true})<CR>", "Reset DAP UI view" },
    i = { ":DapStepIn<CR>", "Step In" },
    o = { ":DapStepOut<CR>", "Step Out" },
    s = { ":lua require'dap.ui.variables'.scopes()<CR>", "Scopes" },
    v = { ":lua require'dap.ui.variables'.visual_hover()<CR>", "Visual Hover" },
    e = { ":lua require'dap.ui.expressions'.eval()<CR>", "Eval" },
    h = { ":lua require'dap.ui.widgets'.hover()<CR>", "Hover" },
    t = { ":DapTerminate<CR>", "Terminate" },
  },
  o = {
    name = "Obsidian",
    d = { ":ObsidianToday<CR>", "Today" },
    n = { ":ObsidianNew<CR>", "New Note" },
  },
  L = {
    name = "Laravel",
    a = { ":Laravel artisan<CR>", "Artisan" },
    r = { ":Laravel routes<CR>", "Routes" },
    m = { ":Laravel related<CR>", "Related" },
  },
  t = {
    name = "Testing",
    f = { ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', "Run File" },
    o = { ":Neotest output<CR>", "Output" },
    s = { ":Neotest summary<CR>", "Summary" },
  },
  v = {
    name = "View",
    m = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown Preview" },
  },
}

which_key.setup(setup)
which_key.register(mappings, opts)
