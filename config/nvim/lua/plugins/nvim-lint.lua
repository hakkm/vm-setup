local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  python = { --[[ "pylint", ]]
    -- "flake8",
    "ruff"
  },
  -- python = { "pylint", --[[ "flake8" ]] },
  twig = { "djlint" },
  htmldjango = { "djlint" },
  c = { "cpplint" },
  cpp = { "cpplint" },
  -- blade = { "tlint" },
  php = { "tlint" },
  json = { "jsonlint" },
  java = { "checkstyle" },
  -- sh = { "shellharden" },
  docker = {"hadolint"},
  -- shell = { "shellcheck" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--   group = lint_augroup,
--   callback = function()
--     lint.try_lint()
--   end,
-- })

vim.keymap.set("n", "<leader>lb", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
-- keybinding to stop linting
vim.keymap.set("n", "<leader>lB", function()
  lint.stop_lint()
end, { desc = "Stop linting for current file" })
