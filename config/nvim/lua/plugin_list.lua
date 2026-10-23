local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  assert(vim.v.shell_error == 0, "Could not clone lazy.nvim")
  vim.fn.system({ "git", "-C", lazypath, "checkout", "306a05526ada86a7b30af95c5cc81ffba93fef97" })
  assert(vim.v.shell_error == 0, "Could not pin lazy.nvim")
end
vim.opt.rtp:prepend(lazypath) -- prepend add to start of runtime table
-- like:
-- vim.opt.rtp.prepend(vim.opt.rtp, lazypath)
require("lazy").setup({
  { "github/copilot.vim" },
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

  {
    -- LSP
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim", version = "1.*" },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim",       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp", after = "nvim-cmp" },
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.tree")
    end,
  },
  { "folke/which-key.nvim",  version="v1.4.2",    opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "numToStr/Comment.nvim",                      opts = {} },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "milisims/nvim-luaref",                       event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("lazygit")
    end,
  },
  { "lewis6991/gitsigns.nvim" },
  { "akinsho/toggleterm.nvim" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- equiv to setup()
  },
  { "CRAG666/code_runner.nvim",    event = "VeryLazy" },
  {
    "lervag/vimtex", --[[ event = "VeryLazy" ]]
  },
  { "smoka7/hop.nvim",            event = "VeryLazy" },
  { "ziontee113/icon-picker.nvim", event = "VeryLazy" },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-dap-python",
    event = "VeryLazy",
    config = function()
      require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "vscode",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
  { "alvarosevilla95/luatab.nvim",         event = "VeryLazy" },
  { "rafcamlet/nvim-luapad",               event = "VeryLazy" },
  { "folke/trouble.nvim",                  event = "VeryLazy" },
  { "Eandrju/cellular-automaton.nvim",     event = "VeryLazy" },
  { "simrat39/symbols-outline.nvim",       event = "VeryLazy" },
  { "RRethy/vim-illuminate",               event = "VeryLazy" },
  { "rcarriga/nvim-notify",                event = "VeryLazy" },
  -- { 'airblade/vim-rooter',             event = "VeryLazy" },
  { "DrKJeff16/project.nvim" },
  -- { 'Bekaboo/dropbar.nvim' }, -- requires nvim 10.0.0
  -- { 'SmiteshP/nvim-navic',             dependencies = "neovim/nvim-lspconfig" },
  -- { 'nvim-orgmode/orgmode',                event = 'VeryLazy' },
  { "stevearc/dressing.nvim",              event = "VeryLazy" },
  { "antosha417/nvim-lsp-file-operations", config = true },
  { "m-demare/hlargs.nvim" },
  { "edluffy/hologram.nvim",               event = "VeryLazy" },
  -- colorschemes
  { "askfiy/visual_studio_code",           event = "VeryLazy" },
  { "shaeinst/roshnivim-cs",               event = "VeryLazy" },
  { "rafamadriz/neon",                     event = "VeryLazy" },
  { "tomasiser/vim-code-dark",             event = "VeryLazy" },
  { "lourenci/github-colors",              event = "VeryLazy" },
  { "sainnhe/gruvbox-material",            event = "VeryLazy" },
  { "NTBBloodbath/doom-one.nvim",          event = "VeryLazy" },
  { "dracula/vim",                         event = "VeryLazy" },
  { "yashguptaz/calvera-dark.nvim",        event = "VeryLazy" },
  { "nxvu699134/vn-night.nvim",            event = "VeryLazy" },
  { "olimorris/onedarkpro.nvim",           event = "VeryLazy" },
  { "luisiacc/gruvbox-baby",               event = "VeryLazy" },
  { "kvrohit/rasmus.nvim",                 event = "VeryLazy" },
  { "dasupradyumna/midnight.nvim",         event = "VeryLazy" },
  { "xero/miasma.nvim",                    event = "VeryLazy" },
  { "ray-x/starry.nvim",                   event = "VeryLazy" },
  { "Mofiqul/vscode.nvim",                 event = "VeryLazy" },
  { "rebelot/kanagawa.nvim",               event = "VeryLazy" },
  { "sainnhe/everforest",                  event = "VeryLazy" },
  { "catppuccin/nvim",                     event = "VeryLazy" },
  { "EdenEast/nightfox.nvim",              event = "VeryLazy" },
  -- end colorscheme
  {
    "2kabhishek/nerdy.nvim",
    event = "VeryLazy",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
  { "folke/zen-mode.nvim", event = "VeryLazy" },
  { "gelguy/wilder.nvim",  event = "VeryLazy" },
  -- { "rmagatti/auto-session", event = "VeryLazy" },
  {
    "doxnit/cmp-luasnip-choice",
    config = function()
      require("cmp_luasnip_choice").setup({
        auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
      })
    end,
  },
  { "metakirby5/codi.vim" },
  {
    "https://gitlab.com/itaranto/plantuml.nvim",
    version = "*",
    config = function()
      require("plantuml").setup()
    end,
  },
  { "dstein64/vim-startuptime", event = "VeryLazy" },
  -- { 'nelsyeung/twig.vim' },
  { "dinhhuy258/vim-database" },
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      -- "kristijanhusak/vim-dadbod-completion",
    },
  },
  { "stevearc/conform.nvim",     opt = {},          event = "VeryLazy" },
  { "mfussenegger/nvim-lint",    event = "VeryLazy" },
  -- { 'luk400/vim-jukit' },
  { "EmranMR/tree-sitter-blade", event = "VeryLazy", submodules = false },
  { "rebelot/kanagawa.nvim" },
  { "klen/nvim-test",          event = "VeryLazy" },
  { "folke/todo-comments.nvim" },
  {
    "nvim-neotest/neotest",
    -- event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "nvim-neotest/neotest-python" },
  { "luckasRanarison/tailwind-tools.nvim", event = "VeryLazy" },
  { "xiyaowong/telescope-emoji.nvim",      event = "VeryLazy" },
  { "brenoprata10/nvim-highlight-colors",  event = "VeryLazy" },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  { 'segeljakt/vim-silicon' },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install && git restore -- yarn.lock",
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      kulala_keymaps = {
        ["Close response"] = {
          "<C-p>",
          function()
            require("kulala").close()
          end,
        },
      },
    },
    keys = {
      {
        "<leader>Rs",
        function()
          require("kulala").run()
        end,
        desc = "Send HTTP request",
      },
      {
        "<leader>Ra",
        function()
          require("kulala").run_all()
        end,
        desc = "Send all HTTP requests",
      },
      {
        "<leader>Rr",
        function()
          require("kulala").replay()
        end,
        desc = "Replay last HTTP request",
      },
    },
  },
}, {
  defaults = { lazy = vim.env.VM_SETUP_BOOTSTRAP == "1" },
  install = { missing = vim.env.VM_SETUP_BOOTSTRAP ~= "1" },
})
