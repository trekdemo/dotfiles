-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local custom_autocmds = vim.api.nvim_create_augroup('custom-autocmds', { clear = true })

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  desc = 'Display cursor line',
  group = custom_autocmds,
  callback = function()
    vim.opt.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  desc = 'Hide cursor line',
  group = custom_autocmds,
  callback = function()
    vim.opt.cursorline = false
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'Do not display line numbers in terminal buffers',
  group = custom_autocmds,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Quit using "q" from certain buffers
-- Source:https://github.com/Mr-LLLLL/utilities.nvim/blob/main/lua/utilities/init.lua
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {
    'qf',
    'git',
    'fugitive',
    'fugitiveblame',
    'help',
    'guihua',
    'notify',
    'tsplayground',
    'query',
  },
  callback = function(_)
    vim.keymap.set('n', 'q', '<cmd>quit!<cr>', { noremap = true, silent = true, buffer = true })
  end,
  group = custom_autocmds,
})
-- This window opens when "q:" is hit
vim.api.nvim_create_autocmd({ 'CmdwinEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>quit!<cr>', { noremap = true, silent = true, buffer = true })
  end,
  group = custom_autocmds,
})
