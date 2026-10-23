-- vim.opt_local.scrolloff = 0
-- vim.wo.scrolloff = 0
-- vim.bo.scrolloff = 0
print("Setting scrolloff for help files")
vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local" })
