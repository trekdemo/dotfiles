return {
  'smart-splits-nvim/smart-splits.nvim',
  lazy = false,
  dependencies = {
    'https://github.com/rawnly/smart-splits-backend-rex',
  },
  config = function()
    local splits = require 'smart-splits'
    splits.setup {
      mux = {
        backend = 'smart-splits-backend-rex',
        -- Outside Rex (kitty, Ghostty, devpods) there is no backend to detect.
        warn_if_unusable = false,
      },
    }

    vim.keymap.set('n', '<A-h>', splits.move_cursor_left)
    vim.keymap.set('n', '<A-j>', splits.move_cursor_down)
    vim.keymap.set('n', '<A-k>', splits.move_cursor_up)
    vim.keymap.set('n', '<A-l>', splits.move_cursor_right)
  end,
}
