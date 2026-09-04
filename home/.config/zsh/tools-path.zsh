# Put mise's shims and Homebrew on PATH. Sourced from both ~/.zshenv (so every
# zsh gets them, interactive or not) and ~/.zprofile (login shells run
# /etc/zprofile -> path_helper, which shuffles /usr/bin back in front of us).
# Idempotent: `typeset -U path` dedupes, so re-prepending just moves entries up.

typeset -U path PATH

path=(
  "${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)
export PATH
