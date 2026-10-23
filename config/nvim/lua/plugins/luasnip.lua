if vim.g.snippets == "luasnip" then
  print("Fuck snippets Luasnip")
  return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jumb back into it even if you have dyanamic snippet, it updates a you type!.
  history = false,
  update_events = "TextChanged,TextChangedI"
}

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = "Expand Snippet", silent = true, noremap = true })

vim.keymap.set("i", "<c-j>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

vim.keymap.set("i", "<c-k>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end, { silent = true })

vim.keymap.set("n", "<leader><leader>s", ":w | source ~/.config/nvim/lua/plugins/snippets.lua<cr>")

require("luasnip.loaders.from_vscode").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
require("luasnip.loaders.from_snipmate").lazy_load( --[[ { include = { "c" } } ]]) -- Load only python snippets

require 'luasnip'.filetype_extend("php", { "html" })
require 'luasnip'.filetype_extend("twig", { "html" })
require 'luasnip'.filetype_extend("htmldjango", { "html" })
require 'luasnip'.filetype_extend("blade", { "html" })
require 'luasnip'.filetype_extend("typescriptreact", { "html" })
