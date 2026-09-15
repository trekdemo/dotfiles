-- Telescope keymaps are in lua/plugins/telescope.lua
-- if vim.b.did_ftplugin then
--   return
-- end
-- vim.b.did_ftplugin = 1

vim.opt_local.iskeyword:append { '?', '!' }
vim.g.ruby_spellcheck_strings = 1

-- Gary Bernhardt's hashrocket
vim.keymap.set('i', '<C-l>', '<Space>=><Space>', { buffer = true, desc = 'Insert =>' })

-- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
--   a custom keymap for `K` exists.
vim.keymap.set({ 'n', 'v' }, 'K', vim.lsp.buf.hover, { buffer = true })

-- See :help b:dispatch
local file = vim.fn.expand '%:t'
if file:match '_spec.rb$' then
  vim.b.dispatch = 'bin/rspec %:.'
end

-- Ruby LSP - Additional features
-- https://shopify.github.io/ruby-lsp/#vs-code-features

-- Open file handler for Code lenses
vim.lsp.commands['rubyLsp.openFile'] = function(cmd, _)
  local uri_frag = cmd.arguments[1][1]
  local uri, line = uri_frag:match '^(.+)#L(%d+)$'
  if not uri then
    uri = uri_frag
  end
  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_option_value('buflisted', true, { buf = bufnr })
  vim.api.nvim_set_current_buf(bufnr)

  vim.api.nvim_win_set_cursor(0, { tonumber(line) or 1, 0 })
end

-- :RubyDependencies - show gems with their paths
-- https://gist.github.com/semanticart/b66bf71d0f8cdda7deb557e8e3e397c3
vim.api.nvim_buf_create_user_command(0, 'RubyDependencies', function()
  local client = vim.lsp.get_clients({ name = 'ruby_lsp' })[1]
  if client == nil then
    vim.print 'No Ruby LSP client found'
    return
  end

  local params = vim.lsp.util.make_range_params(0, 'utf-16')

  client:request('rubyLsp/workspace/dependencies', params, function(error, result)
    if error then
      print('Error showing deps: ' .. error)
      return
    end

    local qf_list = {}
    for _, item in ipairs(result) do
      table.insert(qf_list, {
        text = string.format('%s (%s)', item.name, item.version),
        filename = item.path,
      })
    end

    vim.fn.setqflist(qf_list)
    vim.cmd 'copen'
  end, 0)
end, {
  nargs = '?',
})
