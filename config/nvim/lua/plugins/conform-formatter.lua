local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- typescript = { { "prettierd", "prettier" } },
    -- typescriptreact = { { "prettier", "prettierd" } },
    -- javascript = { { "prettierd", "prettier" } },
    -- javascriptreact = { { "prettierd", "prettier" } },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    svelte = { "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    markdown = { "prettierd" },
    graphql = { "prettierd" },
    lua = { "stylua" },
    -- python = { "isort","black" },
    python = { 'autopep8' },
    twig = { "djlint" },
    htmldjango = { "djlint" },
    tex = { "latexindent" },
    php = { "phpcbf" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    java = { "clang-format" },
    sh = { "shellharden" },
    -- blade = { "tlint" },
    yaml = {"yamlfmt"},
    shell = { "shfmt" },
    java = { "google-java-format" },
  },
  -- format_on_save = {
  --   lsp_fallback = true,
  --   async = false,
  --   timeout_ms = 500,
  -- },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({
    lsp_fallback = true,
    async = true,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })
