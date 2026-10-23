require('plantuml').setup(
  {
    renderer = {
      type = 'imv',
      options = {
        -- split_cmd = 'vsplit', -- Allowed values: `split`, `vsplit`.
        -- prog = "nsxiv",
        dark_mode = true,
      }
    },
    render_on_write = true, -- Set to false to disable auto-rendering.
  }
)
