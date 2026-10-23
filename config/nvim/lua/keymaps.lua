local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<C-p>", "<C-^>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "kj", "<ESC>", opts)
-- ctrl + backspace to delete a word
---- see :help c_BS ==> CTRL-H						*c_<BS>* *c_CTRL-H* *c_BS*
---- CTRL-H		delete the character before the cursor		*c_CTRL-H*
---- <BS> = CTRL-H = backspace
keymap('i', '<C-H>', '<C-w>', opts)

-- Visual --
-- Stay in indent mode
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)

-- Move text up and down
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "p", '"_dP', opts)

keymap("v", "J", ":m +1<CR>gv=gv", opts)
keymap("v", "K", ":m -2<CR>gv=gv", opts)
keymap("n", "J", ":m +1<CR>gv=gv", opts)
keymap("n", "K", ":m -2<CR>gv=gv", opts)
-- how to use: 1. select text 2. press J or K
-- how it work: when you select text: '<,'> appear in command line
--              so when you press J or K, it will become :'<,'>m +1<CR>gv=gv
--              - m is the move command and +1 is {address} the line number to move to see :help move
--              gv to select the previous selection and = to indent the selection according
--              to the indent rules
--              finally: gv to reselect the previous selection

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Command --
-- foget to use sudo
keymap("n", "<leader>W", ":exe 'silent w !sudo tee %' | :e!<CR>", opts)
keymap("c", "W", ":exe 'silent w !sudo tee %' | :e!", opts)
keymap('c', '<C-H>', '<C-W>', {})
keymap('c', '<C-k>', '<C-p>', term_opts)
keymap('c', '<C-j>', '<C-n>', term_opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- How to set a plugin in Normal mode with which-key
-- local wk = require("which-key")
-- wk.register({
--     g = {
--       p = { ":lua print('File ')<cr>", "hithre" },
--     },
--   },
--   {}
-- )
