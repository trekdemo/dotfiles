local vim = vim

vim.keymap.set('n', '<leader>l<space>', ':Lazy ', { desc = 'Lazy' })

-- Better defaults
vim.keymap.set('n', 'Q', '<nop>')
-- Paste without overwriting default register (doesn't work with other registers)
vim.keymap.set('x', 'p', 'pgvy')
-- Select the previously pasted text
vim.keymap.set('n', 'gp', '`[v`]')
-- Alt + Backspace should delete the last word
vim.keymap.set({ 'i', 'c', 't' }, '<M-BS>', '<C-w>')

-- Delete every buffer except the current one
vim.cmd 'command! BufOnly silent! execute "%bd|e#|bd#"'
vim.keymap.set('n', '<leader>bo', ':BufOnly<CR>')

-- Delete buffer
vim.keymap.set('n', '<C-x>', ':bdelete<CR>')

-- Don't move on *
vim.keymap.set('n', '*', '*Nzzzv')
-- Don't move on J - line join
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep search matches in the middle of the window and pulse the line when moving to them.
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Easier to type, and I never use the default behavior.
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^')
vim.keymap.set({ 'n', 'x', 'o' }, 'L', 'g_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Home>', '^')
vim.keymap.set({ 'n', 'x', 'o' }, '<End>', '$')

-- Have relative jumps in the jump list (bigger than 5)
vim.keymap.set('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'gj']], { expr = true, silent = true })
vim.keymap.set('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'gk']], { expr = true, silent = true })

-- Undo breakpoints
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', '!', '!<c-g>u')
vim.keymap.set('i', '?', '?<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')
vim.keymap.set('i', '[', '[<c-g>u')
vim.keymap.set('i', ']', ']<c-g>u')
vim.keymap.set('i', '(', '(<c-g>u')
vim.keymap.set('i', ')', ')<c-g>u')
vim.keymap.set('i', '{', '{<c-g>u')
vim.keymap.set('i', '}', '}<c-g>u')

-- Open location-list and quickfix list
vim.keymap.set('n', '<leader>lo', ':lopen 35<CR>')
vim.keymap.set('n', '<leader>co', ':copen 35<CR>')
vim.keymap.set('n', '<leader>lc', ':lclose<CR>')
vim.keymap.set('n', '<leader>cc', ':cclose<CR>')

-- Move lines in visual mode
vim.keymap.set('v', '[e', ":move '<-2<CR>gv=gv", { desc = 'Move line up' })
vim.keymap.set('v', ']e', ":move '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('n', '[e', ':move .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('n', ']e', ':move .+1<CR>==', { desc = 'Move line down' })

-- Tab openning and closing
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')

-- Shorcut for quick substitution
vim.keymap.set('n', '<leader>ss', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<left><left><left>]], { desc = 'Replace in file' })

-- Quickly diffing to panes
vim.keymap.set('n', '<leader>dt', ':windo diffthis<CR>')
vim.keymap.set('n', '<leader>du', ':windo diffupdate<CR>')
vim.keymap.set('n', '<leader>do', ':windo diffoff<CR>')
-- Diff and Merge mappings
vim.keymap.set('n', '<leader>dp', ':diffput<CR>')
vim.keymap.set('n', '<leader>dg', ':diffget<CR>')
vim.keymap.set('n', '<leader>dgh', '<cmd>diffget //2<cr>', { desc = 'Get the hunk in the left' })
vim.keymap.set('n', '<leader>dgl', '<cmd>diffget //3<cr>', { desc = 'Get the hunk in the right' })

-- Quickly search
vim.keymap.set('n', '<leader>F', ':grep! <C-r><C-w><CR>', { desc = 'Grep <cword>' })

-- Tab navigation
vim.keymap.set('n', '<TAB>', function()
  if vim.fn.tabpagenr '$' > 1 then
    vim.cmd 'tabnext'
  else
    vim.cmd 'bnext'
  end
end)
vim.keymap.set('n', '<S-TAB>', function()
  if vim.fn.tabpagenr '$' > 1 then
    vim.cmd 'tabprevious'
  else
    vim.cmd 'bprevious'
  end
end)

-- Window splitting and closing
vim.keymap.set('n', '<C-w>v', ':vsplit<CR>')
vim.keymap.set('n', '<C-w>s', ':split<CR>')

-- Window resizing
vim.keymap.set('n', '<M-S-Right>', '5<c-w>>', { desc = 'Grow width by 5' })
vim.keymap.set('n', '<M-S-Left>', '5<c-w><', { desc = 'Shrink width by 5' })
vim.keymap.set('n', '<M-S-Up>', '5<c-w>+', { desc = 'Grow height by 5' })
vim.keymap.set('n', '<M-S-Down>', '5<c-w>-', { desc = 'Shrink height by 5' })

vim.keymap.set('n', '[oc', ':set conceallevel=2 <CR>')
vim.keymap.set('n', ']oc', ':set conceallevel=0 <CR>')

-- Add blank line in normal mode
-- https://vim.fandom.com/wiki/Quickly_adding_and_deleting_empty_lines#:~:text=Starting%20in%20normal%20mode%2C%20you,cursor%20type%2010O%20.
vim.cmd [[
nnoremap <silent>]<space> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent>[<space> :set paste<CR>m`O<Esc>``:set nopaste<CR>
]]

-- Fold mappings
vim.keymap.set('n', 'zf', 'zMzvzz', { desc = 'Focus on current fold' })

-- " Mappings: Command-line {{{
-- " Some helpers to edit mode http://vimcasts.org/e/14
vim.keymap.set('c', '%%', [[<C-R>=fnameescape(expand('%:h')).'/'<cr>]])

-- =============================================================================
-- " Emacs bindings
-- https://www.johndcook.com/blog/emacs_move_cursor/
vim.keymap.set({ 'c', 'i' }, '<C-a>', '<Home>', { desc = 'Beginning line' })
vim.keymap.set({ 'c', 'i' }, '<C-e>', '<End>', { desc = 'End line' })
vim.keymap.set('i', '<C-f>', '<Right>', { desc = 'Next char' })
vim.keymap.set('i', '<C-b>', '<Left>', { desc = 'Previous char' })
vim.keymap.set('i', '<M-f>', '<C-o>w', { desc = 'Next word' })
vim.keymap.set('i', '<M-b>', '<C-o>b', { desc = 'Previous word' })
vim.keymap.set('i', '<C-u>', '<esc>gUiwea', { desc = 'Upcase last word' })

vim.keymap.set('n', '<leader>cr', function()
  vim.fn.system([[osascript -e 'tell application "Google Chrome" to reload active tab of front window']])
end, { desc = 'Reload Chrome tab' })

-- Copy relative file path mapping
vim.keymap.set('n', '<leader>yp', function()
  local relative_path = vim.fn.expand '%'
  if relative_path == '' then
    vim.notify('No file in current buffer', vim.log.levels.WARN)
    return
  end

  vim.fn.setreg('+', relative_path)
  vim.fn.setreg('"', relative_path)
  vim.notify('Copied: ' .. relative_path, vim.log.levels.INFO)
end, { desc = 'Copy relative file path' })

-- Copy symbol name (class/module/method) using Treesitter
vim.keymap.set('n', '<leader>yn', function()
  local ts = vim.treesitter
  local ts_utils = require 'nvim-treesitter.ts_utils'

  -- Node types we're interested in (varies by language)
  local target_types = {
    'module',
    'class',
    'class_definition',
    'class_declaration',
    'function_definition',
    'function_declaration',
    'method_definition',
    'method_declaration',
    'module_definition',
    'module_declaration',
    'const_declaration',
    'constant_declaration',
    'variable_declaration',
    'struct_declaration',
    'interface_declaration',
    'enum_declaration',
    'impl_item',
    'trait_definition',
    'namespace_definition',
  }

  -- Find the symbol by traversing up the tree
  local function find_symbol_node(current_node)
    if not current_node then
      return nil
    end

    local node_type = current_node:type()
    if vim.tbl_contains(target_types, node_type) then
      print(ts.get_node_text(current_node, 0))

      -- Look for name/identifier child nodes
      for child in current_node:iter_children() do
        local child_type = child:type()
        if child_type == 'identifier' or child_type == 'name' or child_type == 'type_identifier' then
          local name = ts.get_node_text(child, 0)
          if name and name ~= '' then
            return name, node_type
          end
        end
      end
    end

    -- Try parent node
    return find_symbol_node(current_node:parent())
  end

  -- Get the node at cursor position
  local node = ts_utils.get_node_at_cursor()
  if not node then
    vim.notify('No treesitter node at cursor', vim.log.levels.WARN)
    return
  end
  local symbol_name, symbol_type = find_symbol_node(node)

  if symbol_name then
    vim.fn.setreg('+', symbol_name)
    vim.fn.setreg('"', symbol_name)

    -- Clean up the symbol type for display
    local display_type = symbol_type:gsub('_', ' '):gsub('definition', ''):gsub('declaration', ''):gsub('%s+', ' ')
    vim.notify('Copied ' .. display_type .. ': ' .. symbol_name, vim.log.levels.INFO)
  else
    vim.notify('No symbol found at cursor', vim.log.levels.WARN)
  end
end, { desc = 'Copy symbol name at cursor' })
