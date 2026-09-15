#!/bin/zsh

# https://github.com/junegunn/fzf?tab=readme-ov-file#fuzzy-completion-for-bash-and-zsh
# `fzf --zsh` needs fzf >= 0.48; older distro packages (Ubuntu 24.04 ships 0.44)
# put the same scripts under /usr/share instead.
if fzf --zsh >/dev/null 2>&1; then
  source <(fzf --zsh)
else
  for _f in /usr/share/doc/fzf/examples/key-bindings.zsh /usr/share/doc/fzf/examples/completion.zsh; do
    [ -f "$_f" ] && source "$_f"
  done
  unset _f
fi

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

# Add FZF completion for git checkout <branch>
# Type git <command> **<Tab>
_fzf_complete_git() {
  local tokens=(${(z)1})

  case "${tokens[2]}" in
    co|checkout|diff)
      _fzf_complete --multi --reverse --prompt="git branches> " -- "$1" < <(git branch --no-contains HEAD --list)
      ;;
    *)
      _fzf_path_completion "$prefix" "$1"
      ;;
  esac
}

# Switch to a prject directory
pj() {
  local projects_dir=~/projects
  local selected
  selected=$(find "$projects_dir" -mindepth 1 -maxdepth 1 -type d | sed "s|$projects_dir/||" | fzf) || return
  cd "$projects_dir/$selected"
}
