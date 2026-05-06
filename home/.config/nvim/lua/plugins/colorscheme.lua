local specs = {
  -- https://github.com/EdenEast/nightfox.nvim#configuration
  { "EdenEast/nightfox.nvim" },
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

for _, spec in ipairs(specs) do
  spec.lazy = false      -- make sure we load this during startup if it is your main colorscheme
  if spec.name == 'catppuccin' then
    spec.priority = 1000 -- make sure to load this before all the other start plugins
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
