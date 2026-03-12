return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote

    -- Better Around/Inside textobjects
    local ai = require 'mini.ai'
    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter { -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        },
        f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
        c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },       -- class
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },          -- tags
        d = { '%f[%d]%d+' },                                                         -- digits
        e = {                                                                        -- Word with case
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
        u = ai.gen_spec.function_call(),                          -- u for "Usage"
        U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
      },
    }

    -- require('mini.animate').setup {
    --   cursor = { enable = false },
    --   resize = { enable = false },
    -- }

    -- Buffer	[B [b ]b ]B	MiniBracketed.buffer()
    -- Comment block	[C [c ]c ]C	MiniBracketed.comment()
    -- Conflict marker	[X [x ]x ]X	MiniBracketed.conflict()
    -- Diagnostic	[D [d ]d ]D	MiniBracketed.diagnostic()
    -- File on disk	[F [f ]f ]F	MiniBracketed.file()
    -- Indent change	[I [i ]i ]I	MiniBracketed.indent()
    -- Jump from jumplist inside current buffer	[J [j ]j ]J	MiniBracketed.jump()
    -- Location from location list	[L [l ]l ]L	MiniBracketed.location()
    -- Old files	[O [o ]o ]O	MiniBracketed.oldfile()
    -- Quickfix entry from quickfix list	[Q [q ]q ]Q	MiniBracketed.quickfix()
    -- Tree-sitter node and parents	[T [t ]t ]T	MiniBracketed.treesitter()
    -- Undo states from specially tracked linear history	[U [u ]u ]U	MiniBracketed.undo()
    -- Window in current tab	[W [w ]w ]W	MiniBracketed.window()
    -- selection replacing latest put region	[Y [y ]y ]Y	MiniBracketed.yank()
    require('mini.bracketed').setup {}
    require('mini.pairs').setup()

    -- Text objects: ii and  ai
    -- Motions: [i and ]i
    require('mini.indentscope').setup { symbol = '│' }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup {}

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
    statusline.setup {
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 999 }
          local filename = statusline.section_filename { trunc_width = 140 }
          local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
          local lsp = statusline.section_lsp { trunc_width = 75 }
          local location = statusline.section_location { trunc_width = 75 }

          return statusline.combine_groups {
            { hl = mode_hl,                  strings = { mode } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = 'MiniStatuslineFileinfo', strings = { lsp } },
            { hl = mode_hl,                  strings = { location } },
          }
        end,
      },
    }

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
