#!/bin/zsh

# https://github.com/junegunn/fzf?tab=readme-ov-file#fuzzy-completion-for-bash-and-zsh
source <(fzf --zsh)

if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
else
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi
alias eff='$EDITOR "$(ff)"'

# Add FZF completion for brew commands
# Type brew <command> **<Tab>
_fzf_complete_brew() {
  _fzf_complete --multi --reverse --prompt="brew packages> " -- "$@" < <(brew list)
}

# Switch to a prject directory
pj() {
  local projects_dir=~/projects
  local selected
  selected=$(find "$projects_dir" -mindepth 1 -maxdepth 1 -type d | sed "s|$projects_dir/||" | fzf) || return
  cd "$projects_dir/$selected"
}
