-- Distraction-free coding for Neovim >= 0.5
-- https://github.com/folke/zen-mode.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
return {
  'folke/zen-mode.nvim',
  dependencies = {
    { 'folke/twilight.nvim', opts = {} },
  },
  keys = { { '<leader>z', '<Cmd>ZenMode<CR>' } },
  commands = { 'ZenMode' },
  config = function()
    require('zen-mode').setup {
      window = {
        backdrop = 1,             -- Shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 100,              -- Width of the Zen window
        height = 0.8,             -- Height of the Zen window
        options = {
          number = false,         -- disable number column
          relativenumber = false, -- disable relative numbers
        },
      },
      plugins = {
        twilight = { enabled = false },
        gitsigns = { enabled = false },
        todo = { enabled = false },
        tmux = { enabled = true },
        kitty = {
          enabled = true,
          -- font = '+2',
        },
      },
    }
  end,
}
