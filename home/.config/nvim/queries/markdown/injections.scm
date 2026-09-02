; Overrides nvim-treesitter's bundled query (no "; extends" header, so this
; file fully replaces it rather than merging). Upstream's `(#set-lang-from-info-string!)`
; directive (lua/nvim-treesitter/query_predicates.lua) crashes Neovim 0.12's
; treesitter highlighter on every fenced code block:
; "attempt to call method 'range' (a nil value)" in languagetree.lua/query.lua
; during `_apply_directives`. Using the core `@injection.language` capture
; convention instead avoids that handler entirely. This loses upstream's
; filetype-based alias resolution for info strings, so common short aliases
; are mapped explicitly below; anything else falls back to matching the
; info string verbatim against an installed parser name.
; See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8618

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "js" "jsx")
  (#set! injection.language "javascript"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "ts")
  (#set! injection.language "typescript"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "sh" "shell" "zsh")
  (#set! injection.language "bash"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "py")
  (#set! injection.language "python"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "rb")
  (#set! injection.language "ruby"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "yml")
  (#set! injection.language "yaml"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#any-of? @_lang "md")
  (#set! injection.language "markdown"))

(fenced_code_block
  (info_string (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
