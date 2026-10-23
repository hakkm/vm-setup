-- vim.opt.fillchars = { eob = " " }               -- don't show tilde on end of buffer
-- vim.opt.backup = false                          -- creates a backup file
-- vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
-- vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0
-- vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
-- vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.mouse = "a"      -- allow the mouse to be used in neovim
-- vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
-- vim.opt.showtabline = 1                         -- bufferline
-- vim.opt.laststatus = 2                          -- always display the status line
vim.opt.smartindent = true -- make indenting smarter again
-- vim.opt.swapfile = false                        -- creates a swapfile
-- vim.opt.timeoutlen = 300                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
-- vim.opt.updatetime = 300                        -- faster completion (4000ms default)
-- vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.cursorline = true         -- highlight the current line
vim.opt.number = true             -- set numbered lines
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.relativenumber = true     -- set relative numbered lines
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.numberwidth = 2           -- set number column width to 2 {default 4}
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2               -- insert 2 spaces for a tab

-- vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false              -- display lines as one long line
vim.opt.termguicolors = true      -- set term gui colors (most terminals support this)
vim.opt.inccommand = "split"      -- incrementally show result of command
-- vim.opt.colorcolumn = "80"                      -- set color column to 80
-- vim.opt.linebreak = true                        -- companion to wrap, don't split words
vim.opt.scrolloff = 8     -- 999: if you want it in the middle minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
-- vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
-- vim.opt.whichwrap = "bs<>[]hl"                  -- which "horizontal" keys are allowed to travel to prev/next line
vim.opt.virtualedit = "block"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.mapleader = " "
vim.g.maplocalleader = "."
vim.opt.foldcolumn = "auto"
vim.g.autoindent = true
vim.opt.foldenable = true


-- tsx comments
vim.g.skip_ts_context_commentstring_module = true

-- Suppress deprecation warnings globally for a clean startup
vim.deprecate = function() end

-- Fix for Comment.nvim compatibility with Neovim 0.12+ (where get_parser no longer throws)
local original_get_parser = vim.treesitter.get_parser
vim.treesitter.get_parser = function(bufnr, lang, opts)
  local parser = original_get_parser(bufnr, lang, opts)
  if not parser then
    for i = 2, 5 do
      local info = debug.getinfo(i, "S")
      if info and info.source and (info.source:match("Comment") or info.source:match("ts_context_commentstring")) then
        error("Parser not found")
      end
    end
  end
  return parser
end

