return {
  'stevearc/aerial.nvim',
  opts = {},
  config = function()
    require('aerial').setup {
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 25,

      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    }
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set('n', '<leader>ar', '<cmd>AerialToggle!<CR>')
  end,
}
