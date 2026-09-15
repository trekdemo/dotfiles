# https://github.com/olets/zsh-abbr
#
# macOS: installed with Homebrew (see .Brewfile).
# Linux: cloned to ~/.local/share/zsh-abbr by install.sh.
# The abbreviations live in ~/.config/zsh/abbreviations, zsh-abbr's default location.
typeset -a _abbr_candidates=("$HOME/.local/share/zsh-abbr/zsh-abbr.zsh")
(( $+commands[brew] )) && _abbr_candidates=("$(brew --prefix)/share/zsh-abbr/zsh-abbr.zsh" $_abbr_candidates)

for _abbr in $_abbr_candidates; do
  if [ -f "$_abbr" ]; then
    source "$_abbr"
    break
  fi
done
unset _abbr _abbr_candidates
