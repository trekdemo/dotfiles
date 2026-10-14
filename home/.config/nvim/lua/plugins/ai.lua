return {
  {
    'ThorstenRhau/brygga.nvim',
    version = '*',
    config = function()
      require('brygga').setup {
        auto_start = true,
      }
      vim.keymap.set('x', '<leader>cs', ':Brygga send<CR>', { desc = 'Send selection to Claude' })
    end,
  },
}
