return {
  'romus204/tree-sitter-manager.nvim',
  dependencies = {}, -- tree-sitter CLI must be installed system-wide
  config = function()
    require('tree-sitter-manager').setup {
      ensure_installed = {
        'http',
        'ruby',
        'json',
        'yaml',
        'sql',
        'go',
        'query',
        'html',
        'css',
        'lua',
        'vim',
        'vimdoc',
        'bash',
        'javascript',
        'typescript',
        'tsx',
        'c',
        'make',
        'markdown',
        'markdown_inline',
        'diff',
        'python',
        'mermaid',
      },
    }
  end,
}
