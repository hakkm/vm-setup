local status_ok, icon_picker = pcall(require, "icon-picker")
if not status_ok then return end

icon_picker.setup {
  disable_legacy_commands = true,
  default = " ",
  picker = " ",
  selected = " ",
  separator = " ",
  icons = {
    Class = " ",
    Color = " ",
    Constant = "ﲀ ",
    Constructor = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = "ﰠ ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = " ",
    Property = "ﰠ ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
  },
}


local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader><leader>i", "<cmd>IconPickerNormal<cr>", opts)
vim.keymap.set("n", "<leader><leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
-- vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
