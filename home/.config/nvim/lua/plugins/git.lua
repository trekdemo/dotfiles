return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = { numhl = true },
    events = { 'BufReadPre' },
  },

  -- A Git wrapper so awesome, it should be illegal
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
      'https://forge.barrettruth.com/barrettruth/diffs.nvim',
      init = function()
        vim.g.diffs = {
          integrations = {
            fugitive = true,
            gitsigns = true,
          },
        }
      end,
    },
    commands = { 'Git' },
    keys = {
      { '<leader>g<Space>', ':Git<Space>' },
      { '<leader>gs', '<CMD>Git<cr>' },
      { '<leader>gw', '<CMD>Gwrite<cr>' },
      { '<leader>ga', '<CMD>Gadd<cr>' },
      { '<leader>gb', '<CMD>Git blame<CR>' },
      { '<leader>gl', '<CMD>Git bl<CR>' },
      { '<leader>ghp', ':!gh pr view -w || gh pr create -w<cr>', { desc = 'Create or view GitHub PR' } },
    },
  },
}
