return {
  'vim-test/vim-test',
  dependencies = { 'vim-dispatch' },
  keys = {
    { '<leader>tl', '<Cmd>TestLast<CR>',      { desc = '[T]est [L]ast' } },
    { '<leader>ta', '<Cmd>AbortDispatch<CR>', { desc = '[T]est Dispatch [A]bort' } },
    { '<leader>tn', '<Cmd>TestNearest<CR>',   { desc = '[T]est [N]earest' } },
    { '<leader>tf', '<Cmd>TestFile<CR>',      { desc = '[T]est [F]ile' } },
    { '<leader>ts', '<Cmd>TestSuite<CR>',     { desc = '[T]est [S]uite' } },
  },
  config = function()
    vim.g['test#strategy'] = 'wezterm'

    local switchStrategy = function(strategy)
      return function()
        vim.g['test#strategy'] = strategy
        vim.notify('Using ' .. strategy .. ' to run tests', vim.log.levels.INFO)
      end
    end
    vim.keymap.set('n', '<leader>tk', switchStrategy 'kitty', { desc = 'Run [T]ests with Kitty' })
    vim.keymap.set('n', '<leader>tt', switchStrategy 'wezterm', { desc = 'Run [T]ests with Wezterm' })
    vim.keymap.set('n', '<leader>td', switchStrategy 'dispatch', { desc = 'Run [T]ests with [D]ispatch' })

    -- [LANGUAGE SPECIFIC SETTINGS] -------------------------------------------
    -- Ruby settings for RSpec
    vim.g['test#ruby#rspec#options'] = {
      nearest = '--format documentation',
      file = '--format documentation',
      suite = '--format progress',
    }
  end,
}
