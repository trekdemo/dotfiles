return {
  'obsidian-nvim/obsidian.nvim',
  -- version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    templates = { folder = 'templates' },
    daily_notes = {
      folder = 'Journal',
    },
    workspaces = {
      {
        name = 'Vault',
        path = '~/Downloads/Notes/',
      },
      {
        name = 'Work',
        path = '~/Documents/Notes/',
      },
    },
  },
}
