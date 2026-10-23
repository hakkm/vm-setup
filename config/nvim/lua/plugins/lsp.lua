local wk = require("which-key")
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  -- -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')          -- ofter don't work
  -- nmap('gD', ":TroubleToggle lsp_definitions<cr>", '[G]oto [D]efinition') -- cause need to be closed after enter
  -- nmap('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  -- nmap("gr", ":TroubleToggle lsp_references<cr>", '[G]oto [R]eferences')
  -- nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  -- nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- REMEMBER: in which-key you have to call the function something like the line below will not work
  -- d = { "<cmd>lua require('telescope.builtin').lsp_definitions<cr>", "Goto Definition Telescope" },
  wk.register({
    g = {
      d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "Goto Definition Telescope" },
      D = { "<cmd>Trouble lsp_definitions<cr>", "Goto Defintion" },
      R = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "Goto References Telescope" },
      r = { "<cmd>Trouble lsp_references<cr>", "Goto References" },
      i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "Goto Implementations Telescope" },
      l = { "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line' })<cr>", "Line Diagnostics" },
    },
  }, { buffer = bufnr })
  -- Lesser used LSP functionality
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
end

require("mason").setup()
require("mason-lspconfig").setup()


local servers = {
  clangd = { filetypes = { "c", "cpp" } },
  -- gopls = {},
  pyright = { filetypes = { "py", "python" } },
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  -- ltex = { filetypes = { 'tex', 'bib', 'markdown' } },
  intelephense = { filetypes = { "php", "php.html" } },
  stimulus_ls = { filetypes = { "blade" } },
  -- twig_language_server = { filetypes = { 'twig' } },
  -- lua_ls = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  -- --     -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
  --     diagnostics = { disable = { 'missing-fields' } },
  --   },
  -- },
  -- tsserver = {
  --   typescript = {
  --     tsconfig = "tsconfig.json",
  --     telemetry = { enable = false },
  --     diagnostics = { enable = true },
  --     completion = { autoImport = true },
  --     semanticTokens = { enable = false },
  --   },
  --   javascript = {
  --     tsconfig = "tsconfig.json",
  --     telemetry = { enable = false },
  --     diagnostics = { enable = true },
  --     completion = { autoImport = true },
  --     semanticTokens = { enable = false },
  --   },
  -- },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = { "utf-16" }

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})
local lspconfig = require("lspconfig")
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      handlers = {
        ["textDocument/rename"] = function(err, result, ctx, config)
          if err then
            vim.notify('LSP rename failed: ' .. tostring(err), vim.log.levels.ERROR)
            return
          end

          if result and result.documentChanges then
            for _, change in ipairs(result.documentChanges) do
              if change.edits then
                for _, edit in ipairs(change.edits) do
                  edit.annotationId = nil
                end
              end
            end
          end

          vim.lsp.handlers["textDocument/rename"](err, result, ctx, config)
        end,
      },
    })
  end,
})

-- you can also do this instead
-- require("lspconfig").lua_ls.setup {}

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- for more options see :h vim.diagnostic.config()
local config = {
  virtual_text = false,
  check_current_line = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    border = "single",
    style = "minimal",
  },
}

vim.diagnostic.config(config)

-- disable semantic tokens for all servers
-- because it prevants hlargs.nvim plugin from working

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- require("crates").setup({
--   lsp = {
--     enabled = true,
--     -- on_attach = function(client, bufnr)
--     --     -- the same on_attach function as for your other lsp's
--     -- end,
--     actions = true,
--     completion = true,
--     hover = true,
--   },
-- })
