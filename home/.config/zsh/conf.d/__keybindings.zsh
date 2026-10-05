autoload -Uz edit-command-line

bindkey -e

exit_zsh() { exit }
zle -N exit_zsh
bindkey '^X' exit_zsh

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char # C-?
bindkey '^h' backward-delete-char # C-h
bindkey '^w' backward-kill-word # C-w
bindkey '^[^?' backward-kill-word # Alt-Backspace

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

bindkey '^a' beginning-of-line # C-a
bindkey '^e' end-of-line # C-e
bindkey '^[[H' beginning-of-line # Home
bindkey '^[[F' end-of-line # End

# Word-wise movements
bindkey '^[[1;3C' .forward-word # Alt-Right
bindkey '^[[1;3D' .backward-word # Alt-Left

# Create a ZSH widget that can be bound to a key
# https://unix.stackexchange.com/questions/289883/binding-key-shortcuts-to-shell-functions-in-zsh

# Open In Neovim
open-vim-here() { nvim . }
zle -N open-vim-here
bindkey '^[v' open-vim-here


# Jump to a project folder
jump-to-folder() {
  setopt local_options
  setopt +o nomatch
  local dir="cd $(ls -rdt ~/projects/* | fzf --layout=reverse)"

  ${=dir}
  zle reset-prompt
}
zle -N jump-to-folder
bindkey '^J' jump-to-folder

# Jump to another worktree of the current git repository
jump-to-worktree() {
  local selected
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    zle -M "Not inside a git repository"
    return 1
  fi

  # Lines look like "<path>  <sha> [<branch>]"; bare repos have no checkout to jump to
  selected=$(git worktree list | grep -v ' (bare)$' | fzf --layout=reverse --prompt="worktree> ") || {
    zle reset-prompt
    return 0
  }

  cd "$(sed -E 's/ +[0-9a-f]{7,} .*$//' <<< "$selected")"
  zle reset-prompt
}
zle -N jump-to-worktree
bindkey '^G' jump-to-worktree
