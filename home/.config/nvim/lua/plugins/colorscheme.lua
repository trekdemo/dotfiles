return {
  {
    'afonsofrancof/OSC11.nvim',
    init = function()
      local function get_macos_appearance()
        local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          if result:match 'Dark' then
            return 'dark'
          end
        end
        return 'light'
      end

      -- Set background and colorscheme based on macOS mode
      vim.o.background = get_macos_appearance()

      -- Example: change colorscheme to match
      if vim.o.background == 'dark' then
        vim.opt.background = 'dark'
        vim.cmd 'colorscheme catppuccin-macchiato'
      else
        vim.opt.background = 'light'
        vim.cmd 'colorscheme seoulbones'
      end
    end,
    opts = {
      -- Function to call when switching to dark theme
      on_dark = function()
        vim.opt.background = 'dark'
        vim.cmd 'colorscheme catppuccin-macchiato'
      end,
      -- Function to call when switching to light theme
      on_light = function()
        vim.opt.background = 'light'
        vim.cmd 'colorscheme seoulbones'
      end,
    },
  },
  {
    'zenbones-theme/zenbones.nvim',
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
  },
  -- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        background = {
          light = 'latte',
          dark = 'macchiato',
        },
        styles = {
          comments = {}, -- Change the style of comments
        },
        transparent_background = true,
        integrations = {
          blink_cmp = true,
          gitsigns = true,
          treesitter = true,
          treesitter_context = true,
          fidget = true,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          which_key = true,
          dadbod_ui = true,
          dap = true,
          dap_ui = true,
          markdown = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
          },
        },
      }
      vim.cmd.hi('link', 'QuickfixLine', 'CursorLine')
    end,
  },
}
