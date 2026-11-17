vim.g.markdown_fenced_languages = { 'yaml', 'ruby', 'json', 'jsonc', 'sh', 'javascript', 'diff', 'python', 'mermaid' }

vim.opt_local.spell = true
vim.opt_local.spelllang = { 'en', 'hu' }
vim.opt_local.textwidth = 80
vim.opt_local.formatoptions = 'nbl' -- *fo-table*
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = 'shift:-1,list:-1,sbr'
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ''

vim.keymap.set('n', 'ss', ']s', { buffer = true, silent = true, remap = true })

vim.api.nvim_set_hl(0, '@markup.link.url', { link = 'Comment' })

-- <M-p> toggles a Rex pane beside the editor that renders this file with tkmp.
-- The pane's block id lives in b:tkmp_block, so each buffer owns its preview.
-- Outside Rex, or without tkmp, it falls back to markdown-preview.nvim.
local can_preview_in_rex = vim.env.REX_BLOCK
  and vim.fn.executable('rex') == 1
  and vim.fn.executable('tkmp') == 1

if not can_preview_in_rex then
  vim.keymap.set('n', '<M-p>', '<Cmd>MarkdownPreviewToggle<CR>', { buffer = true, silent = true, desc = 'Toggle markdown preview' })
else
  local function toggle_tkmp_preview()
    local block = vim.b.tkmp_block
    if block and vim.system({ 'rex', 'block', 'inspect', block }):wait().code == 0 then
      vim.system({ 'rex', 'block', 'close', block }):wait()
      vim.b.tkmp_block = nil
      return
    end

    local result = vim.system({
      'rex', 'split', '-b', vim.env.REX_BLOCK, '--focus=false', '--json',
      '--label', 'tkmp', '-c', vim.fn.getcwd(), '--', 'tkmp', vim.fn.expand('%:p'),
    }, { text = true }):wait()
    if result.code ~= 0 then
      vim.notify('rex split failed: ' .. (result.stderr or ''), vim.log.levels.ERROR)
      return
    end
    vim.b.tkmp_block = vim.json.decode(result.stdout).block_ids[1]
  end

  vim.keymap.set('n', '<M-p>', toggle_tkmp_preview, { buffer = true, silent = true, desc = 'Toggle tkmp preview' })
end
