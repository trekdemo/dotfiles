return {
  'smart-splits-nvim/smart-splits.nvim',
  lazy = false,
  config = function()
    local splits = require 'smart-splits'
    splits.setup {}

    vim.keymap.set('n', '<A-h>', splits.move_cursor_left)
    vim.keymap.set('n', '<A-j>', splits.move_cursor_down)
    vim.keymap.set('n', '<A-k>', splits.move_cursor_up)
    vim.keymap.set('n', '<A-l>', splits.move_cursor_right)
  end,
}
