return {
  -- 'tpope/vim-dispatch',
  'trekdemo/vim-dispatch',
  branch = 'wezterm-support',
  -- branch = 'kitty-support',
  -- dev = true,
  -- path = '~/projects/vim-dispatch',
  config = function()
    vim.g.dispatch_compilers = { ['bundle exec'] = '', ['bin/'] = '' }
    vim.g.dispatch_quickfix_height = 30

    vim.keymap.set('n', '<leader>co', ':Copen<CR>')  -- Load the output from the last Dispatch
    vim.keymap.set('n', '<leader>cO', ':Copen!<CR>') -- Load the unfiltered output from the last Dispatch

    vim.keymap.set('n', "'b", ':Start bundle<space>')

    local map_start_cmd = function(mapping, command)
      vim.keymap.set('n', mapping, ':Start ' .. command .. '<CR>')
    end

    map_start_cmd("'c", 'bin/dcr')
    map_start_cmd("'d", 'lazydocker')
    map_start_cmd("'g", 'lazygit')
    map_start_cmd("'h", 'gh dash')
    map_start_cmd("'m", 'rails-mycli')
    map_start_cmd("'n", 'yazi')
    map_start_cmd("'i", 'irb')
    map_start_cmd("'r", 'bin/rails console')
    map_start_cmd("'p", 'pgcli postgresql://postgres@localhost:54320/better_up_development')
  end,
}
