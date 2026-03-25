return {
  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('copilot').setup {
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     }
  --   end,
  -- },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = { file_types = { 'markdown', 'codecompanion' } },
        ft = { 'markdown', 'codecompanion' },
      },
      {
        'ravitemer/mcphub.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
        opts = {},
        cmd = { 'MCPHub' },
      },
    },
    opts = {
      interactions = {
        chat = { adapter = "claudecode", },
      },
      display = {
        chat = {
          -- show_settings = true,
          window = {
            width = 100,
            opts = {
              number = false,
              signcolumn = 'yes:1',
            },
          },
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true,           -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
      },
    },
    init = function()
      vim.cmd [[cab cc CodeCompanion]]
    end,
    keys = {
      -- { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion' },
      -- { '<leader>av', '<cmd>CodeCompanionChat Add<cr>', mode = 'v' },
      -- { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' } },
    },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionActions' },
  },
  {
    'coder/claudecode.nvim',
    -- dependencies = { 'folke/snacks.nvim' },
    provider = 'native', -- "auto", "snacks", "native", or custom provider table
    config = true,
    keys = {
      { '<leader>a',  nil,                              desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',                  desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = 'Deny diff' },
    },
  },
}
