local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key


local function remove_dot(index)
  return f(function(args)
    print(vim.inspect(args[1][1]))
    local parts = vim.split(args[1][1], "%.")
    return parts[#parts]
  end, { index })
end

local function same(index)
  return f(function(args)
    return args[1][1]
  end, { index })
end

ls.add_snippets("lua", {
  s("preq", fmt([[
  local status_ok, {} = pcall(require, "{}")
  if not status_ok then
    vim.notify("{} not found")
    return
  end
  ]], { remove_dot(1), i(1), same(1) })),
  s("lreq", fmt([[local {} = require "{}"]], { same(1), i(1) })),
  s("--", c(1, {
    t("-- "),
    t("-- TODO: "),
    t("-- FIXME: "),
    t("-- OPTIMIZE: "),
    t("-- WARNING: "),
    t("-- HACK: "),
    t("-- NOTE: "),
    t("-- REMEMBER: "),
  })),
  s("event", t "event='VeryLazy',"),
  s("lp", { t '{ "', i(1), t '", event = "VeryLazy" },' }),
  s("example3", fmt([[
      if <> then
        <>
      end
      ]], {
    -- i(1) is at nodes[1], i(2) at nodes[2].
    i(1, "not now"), i(2, "when")
  }, {
    delimiters = "<>"
  })),
  s("wk", fmt([[
    local wk = require("which-key")
    wk.register({
      [] = {
        [] = { "<cmd>[]<cr>", "[]" },
        },
      },
      { prefix = "[]" }
    )
    ]], {
    i(1, "l"), i(2, "a"), i(3, "Command"), i(4, "Name"), i(5, "<leader>")
  }, {
    delimiters = "[]"
  })),
  s("wkac", fmt([[
        [] = { "<cmd>[]<cr>", "[]" },
    ]], {
    i(1, "z"), i(2, "Command"), i(3, "Name")
  }, {
    delimiters = "[]"
  })),
})

ls.add_snippets("python", {
  s({ trig = "fro", name = "from import" }, fmt([[from {} import {}]], { i(1), i(2) })),
})
