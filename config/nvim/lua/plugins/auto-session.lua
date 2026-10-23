local status_ok, autosession = pcall(require, "auto-session")
if not status_ok then
  vim.notify("Missing auto-session dependency", vim.log.levels.ERROR)
  return
end

autosession.setup {
  log_level = "error",
  auto_session_suppress_dirs = nil,
  auto_session_enabled = false,

  cwd_change_handling = {
    restore_upcoming_session = false, -- already the default
    pre_cwd_changed_hook = nil,       -- already the defaul
  },
  session_lens = {
    -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
    buftypes_to_ignore = { "NvimTree" }, -- list of buffer types what should not be deleted from current session
    load_on_setup = false,
    theme_conf = { border = true },
    previewer = false,
  },
}

vim.keymap.set("n", "<C-s>", require("auto-session.session-lens").search_session, {
  noremap = true,
})
