--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- Useful for getting pretty icons, but requires special font.
    --  If you already have a Nerd Font, or terminal set up with fallback fonts
    --  you can enable this
    -- { 'nvim-tree/nvim-web-devicons' }
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of help_tags options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require 'telescope.actions'
    require('telescope').setup {
      defaults = {
        border = true,
        borderchars = {
          preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          prompt = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
          results = { ' ' },
        },
        layout_config = {
          height = 35,
        },
        layout_strategy = 'bottom_pane',
        sorting_strategy = 'ascending',
        theme = 'ivy',
        mappings = {
          i = {
            ['<Esc>'] = actions.close,
            ['<M-l>'] = actions.send_selected_to_loclist + actions.open_loclist,
          },
        },
      },
      pickers = {
        spell_suggest = { theme = 'cursor' },
        find_files = { hidden = true },
        live_grep = { hidden = true },
        buffers = {
          mappings = {
            i = { ['<C-d>'] = 'delete_buffer' },
          },
        },
      },
      extensions = {
        fzf = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable telescope extensions, if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Make accessing Telescope easier
    vim.cmd [[cabbrev t Telescope]]
    vim.keymap.set('n', '<leader>t<space>', ':Telescope ')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Find buffers' })
    vim.keymap.set('n', '<C-q>', builtin.quickfix, { desc = 'Telescope quickfix' })
    vim.keymap.set('n', '<C-t>', function()
      builtin.treesitter { default_text = ':function:' }
    end, { desc = 'Telescope treesitter' })
    vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = 'Telescope live_grep' })
    vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find_files' })

    vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Find [C]ommands' })
    vim.keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols, { desc = 'Find LSP [S]ymbols' })
    vim.keymap.set('n', 'gi', builtin.lsp_definitions, { desc = 'Goto definition' })
    vim.keymap.set('n', '<leader>fi', builtin.lsp_definitions, { desc = 'Goto definition' })
    vim.keymap.set('n', 'gI', function()
      builtin.lsp_definitions { jump_type = 'vsplit' }
    end, { desc = 'Goto defInition in a split' })
    vim.keymap.set('n', '<leader>fI', function()
      builtin.lsp_definitions { jump_type = 'vsplit' }
    end, { desc = 'Goto defInition in a split' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope [D]iagnostics' })
    vim.keymap.set('n', '<leader>ff', builtin.builtin, { desc = 'Telescope builtin' })
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope builtin' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find [H]elp' })
    vim.keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Find key [M]appings' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Find [R]esume' })
    vim.keymap.set('n', '<leader>gg', builtin.git_status, { desc = 'Telescope git_status' })
    vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, { desc = 'Telescope git_bcommits' })
    vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = 'Telescope git_branches' })
    vim.keymap.set('n', '<leader>fp', function()
      local pack_name = string.match(vim.fn.expand '%:h', 'packs/([^/]+)')
      if pack_name then
        builtin.find_files { cwd = 'packs/' .. pack_name }
      else
        builtin.find_files()
      end
    end, { desc = 'Telescope find_files' })

    vim.keymap.set('n', 'z=', builtin.spell_suggest)

    -- Shortcut for searching dotfiles
    vim.keymap.set('n', '<leader>fv', function()
      builtin.find_files { cwd = vim.env.HOME .. '/projects/dotfiles/home/', hidden = true }
    end, { desc = 'Find in dotfiles' })

    local function find_files_within_glob(globs, glob_name)
      return function()
        local find_command = { 'rg', '--files' }

        -- Build the list of directory globs to search in
        if type(globs) == 'string' then
          table.insert(find_command, '--glob')
          table.insert(find_command, globs)
        elseif type(globs) == 'table' then
          for _, glob in ipairs(globs) do
            table.insert(find_command, '--glob')
            table.insert(find_command, glob)
          end
        end

        require('telescope.builtin').find_files {
          prompt_title = 'Find ' .. (glob_name or 'Files'),
          find_command = find_command,
        }
      end
    end

    -- Rails and Ruby related finders
    vim.keymap.set('n', '<leader>ra', find_files_within_glob('**/app/assets/**', 'Assets'), { desc = 'Find Rails Assets' })
    vim.keymap.set(
      'n',
      '<leader>rc',
      find_files_within_glob({ '**/app/controllers/**.rb', '**/app/channels/**', '**/app/admin/**' }, 'Controllers'),
      { desc = 'Find Rails Controllers' }
    )
    vim.keymap.set('n', '<leader>rh', find_files_within_glob('**/app/helpers/**.rb', 'Helpers'), { desc = 'Find Rails Helpers' })
    vim.keymap.set('n', '<leader>rj', find_files_within_glob('**/app/jobs/**.rb', 'Jobs'), { desc = 'Find Rails Jobs' })
    vim.keymap.set('n', '<leader>rl', find_files_within_glob('**/app/mailers/**.rb', 'Mailers'), { desc = 'Find Rails Mailers' })
    vim.keymap.set(
      'n',
      '<leader>rm',
      find_files_within_glob({
        '**/app/models/**.rb',
        '**/app/services/**.rb',
        '**/app/listeners/**.rb',
        '**/app/policies/**.rb',
      }, 'Models and business logic'),
      { desc = 'Find Rails Models and business logic' }
    )
    vim.keymap.set('n', '<leader>rv', find_files_within_glob({ '**/app/views/**', '**/app/serializers/**' }, 'Views'), { desc = 'Find Rails Views' })
    vim.keymap.set('n', '<leader>rs', find_files_within_glob('**/spec/**', 'RSpec Specs'), { desc = 'Find RSpec Specs' })
    vim.keymap.set(
      'n',
      '<leader>rI',
      find_files_within_glob({ 'db/migrate/*.rb', '**/app/jobs/data_migrations/**' }, 'Database Migrations'),
      { desc = 'Find Rails Migrations' }
    )

    vim.keymap.set('n', '<leader>rg', function()
      local gem_paths = vim.split(os.getenv 'GEM_PATH', ':', { trimempty = true })
      local search_dirs = vim.tbl_map(function(path)
        return path .. '/gems'
      end, gem_paths)
      builtin.find_files { search_dirs = search_dirs }
    end, { desc = 'Telescope Find in gems' })

    -- Feature branch changes: git diff --name-only main...HEAD
    local telescope = require 'telescope'
    local finders = require 'telescope.finders'
    local pickers = require 'telescope.pickers'
    local conf = require('telescope.config').values
    local action_state = require 'telescope.actions.state'

    local function git_diff_files(opts)
      opts = opts or {}

      pickers
        .new(opts, {
          prompt_title = 'Changed files (branch vs origin/main)',

          finder = finders.new_oneshot_job({ 'git', 'diff', '--name-only', 'origin/main...HEAD' }, opts),

          sorter = conf.file_sorter(opts),

          previewer = conf.file_previewer(opts),

          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                vim.cmd('edit ' .. selection[1])
              end
            end)
            return true
          end,
        })
        :find()
    end

    -- vim.keymap.set("n", "<leader>gd", git_diff_files, { desc = "Git diff files vs origin/main" })
  end,
}
