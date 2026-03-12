local specs = {
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    config = function()
      vim.opt_global.background = 'dark'
      vim.cmd.colorscheme 'tokyonight-moon'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
      vim.cmd.hi 'Folded guibg=none'
    end,
  },
  -- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        background = {
          light = "latte",
          dark = "frappe",
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
      vim.opt_global.background = 'dark'
      vim.cmd.hi('link', 'QuickfixLine', 'CursorLine')
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}

local name = 'catppuccin'
for _, spec in ipairs(specs) do
  if spec.name == name then
    spec.lazy = false    -- make sure we load this during startup if it is your main colorscheme
    spec.priority = 1000 -- make sure to load this before all the other start plugins
  else
    spec.lazy = true
  end
end

-- Make the background transparent
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

-- Change the name of the colorscheme plugin below, and then
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
return specs
