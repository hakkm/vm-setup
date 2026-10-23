-- -- this is not required even if it did in plugin_init.lua but it's due to the setup in plugin_list.lua
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end
--
-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
-- 	return
-- end
--
local api = require("nvim-tree.api")
--
local function edit_or_open()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
    -- Close the tree if file was opened
    api.tree.close()
  end
end

local function collapse_folder()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()

  if node and node.type == "directory" then
    api.node.open.edit() -- Close the folder
  end
end

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "l", edit_or_open, opts("Open file or folder"))
  vim.keymap.set("n", "i", api.tree.toggle_gitignore_filter, opts("Toggle gitignore filter"))
  vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy absolute path"))
  vim.keymap.set("n", "h", collapse_folder, opts("Collapse folder"))
end

-- local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
  disable_netrw = true,
  on_attach = my_on_attach,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    side = "right",
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  filters = {
    dotfiles = true,
    git_ignored = true,
  },
})
-- 	disable_netrw = true,
-- 	sync_root_with_cwd = true,
-- 	respect_buf_cwd = true,
-- 	update_focused_file = {
-- 		enable = true,
-- 		update_root = true,
-- 	},
-- 	-- renderer = {
-- 	-- 	root_folder_modifier = ":t",
-- 	-- 	icons = {
-- 	-- 		glyphs = {
-- 	-- 			default = "",
-- 	-- 			symlink = "",
-- 	-- 			folder = {
-- 	-- 				arrow_open = "",
-- 	-- 				arrow_closed = "",
-- 	-- 				default = "",
-- 	-- 				open = "",
-- 	-- 				empty = "",
-- 	-- 				empty_open = "",
-- 	-- 				symlink = "",
-- 	-- 				symlink_open = "",
-- 	-- 			},
-- 	-- 			git = {
-- 	-- 				unstaged = "",
-- 	-- 				staged = "S",
-- 	-- 				unmerged = "",
-- 	-- 				renamed = "➜",
-- 	-- 				untracked = "U",
-- 	-- 				deleted = "",
-- 	-- 				ignored = "◌",
-- 	-- 			},
-- 	-- 		},
-- 	-- 	},
-- 	-- },
-- 	-- diagnostics = {
-- 	-- 	enable = true,
-- 	-- 	show_on_dirs = true,
-- 	-- 	icons = {
-- 	-- 		hint = "",
-- 	-- 		info = "",
-- 	-- 		warning = "",
-- 	-- 		error = "",
-- 	-- 	},
-- 	-- },
-- 	view = {
-- 		width = 30,
-- 		side = "right",
-- 		mappings = {
-- 			list = {
-- 				-- { key = { "l", "<CR>", "o" },             cb = tree_cb "edit" },
-- 				{ key = "h", cb = tree_cb("close_node") },
-- 				{ key = "v", cb = tree_cb("vsplit") },
-- 				{ key = "h", cb = tree_cb("split") },
-- 				-- BEGIN-DEFAULT-MAPPINGS
-- 				{ key = { "l", "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
-- 				{ key = "<C-e>", action = "edit_in_place" },
-- 				{ key = "O", action = "edit_no_picker" },
-- 				{ key = { "<C-]>", "<2-RightMouse>" }, action = "cd" },
-- 				{ key = "<C-v>", action = "vsplit" },
-- 				{ key = "<C-h>", action = "split" },
-- 				{ key = "<C-t>", action = "tabnew" },
-- 				{ key = "<", action = "prev_sibling" },
-- 				{ key = ">", action = "next_sibling" },
-- 				{ key = "P", action = "parent_node" },
-- 				{ key = "<BS>", action = "close_node" },
-- 				{ key = "<Tab>", action = "preview" },
-- 				{ key = "K", action = "first_sibling" },
-- 				{ key = "J", action = "last_sibling" },
-- 				{ key = "I", action = "toggle_git_ignored" },
-- 				{ key = "H", action = "toggle_dotfiles" },
-- 				{ key = "U", action = "toggle_custom" },
-- 				{ key = "R", action = "refresh" },
-- 				{ key = "a", action = "create" }, --  add a file; leaving a trailing `/` will add a directory
-- 				{ key = "d", action = "remove" },
-- 				{ key = "D", action = "trash" },
-- 				{ key = "r", action = "rename" },
-- 				{ key = "<C-r>", action = "full_rename" },
-- 				{ key = "x", action = "cut" },
-- 				{ key = "c", action = "copy" },
-- 				{ key = "p", action = "paste" },
-- 				{ key = "y", action = "copy_name" },
-- 				{ key = "Y", action = "copy_path" },
-- 				{ key = "gy", action = "copy_absolute_path" },
-- 				{ key = "[e", action = "prev_diag_item" },
-- 				{ key = "[c", action = "prev_git_item" },
-- 				{ key = "]e", action = "next_diag_item" },
-- 				{ key = "]c", action = "next_git_item" },
-- 				{ key = "-", action = "dir_up" },
-- 				{ key = "s", action = "system_open" },
-- 				{ key = "f", action = "live_filter" },
-- 				{ key = "F", action = "clear_live_filter" },
-- 				{ key = "q", action = "close" },
-- 				{ key = "W", action = "collapse_all" },
-- 				{ key = "E", action = "expand_all" },
-- 				{ key = "S", action = "search_node" },
-- 				{ key = ".", action = "run_file_command" },
-- 				{ key = "<C-k>", action = "toggle_file_info" },
-- 				{ key = "g?", action = "toggle_help" },
-- 				{ key = "m", action = "toggle_mark" },
-- 				{ key = "bmv", action = "bulk_move" },
-- 			},
-- 		},
-- 	},
-- })
