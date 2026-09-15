#!/bin/sh
# Linux installer for devcontainers and devpods.
# macOS is handled by the Makefile (stow + Homebrew); this script is the Linux path.
#
# DevPod clones this repo to ~/dotfiles and runs ./install.sh once, as the
# workspace user, right after the devcontainer's on-create hook has finished.
# Everything here is idempotent, so re-running ~/dotfiles/install.sh by hand is safe.
#
# What it does:
#   1. keeps what the devpod's on-create hook already wrote into ~/.zshrc and
#      ~/.gitconfig (git identity, gh credential helper, GITHUB_API_TOKEN, ...)
#   2. symlinks the selected configs from home/ into $HOME
#   3. installs the CLI tools those configs depend on via mise (present in the
#      devpod image) and clones zsh-abbr
#   4. pre-installs neovim plugins from lazy-lock.json
#
# Env knobs: DOTFILES_SKIP_TOOLS=1 skips step 3, DOTFILES_SKIP_NVIM_SYNC=1 skips step 4.
set -eu

DOTFILES_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
SRC="$DOTFILES_DIR/home"
BACKUP_DIR="$HOME/.local/state/dotfiles/backup-$(date +%Y%m%d%H%M%S)"

# Paths relative to home/. Directories are linked whole. Where a tool keeps
# runtime state next to its config (gh hosts.yml, lazygit state.yml, herdr and
# hunk caches) only the config file is linked so that state stays out of the repo.
LINKS='
.zshenv
.zprofile
.zshrc
.config/zsh
.config/starship.toml
.gitmessage
.gitattributes
.config/git
.config/gh/config.yml
.config/nvim
.config/lazygit/config.yml
.config/herdr/config.toml
.config/hunk/config.toml
.config/yazi
.claude/agents
.claude/commands
.claude/skills
.agents/skills
'

# Tools the linked configs need and the devpod image does not ship.
# Already in the image: git gh zsh tmux fzf(0.44) fd ripgrep nvim herdr mise.
TOOLS='starship zoxide eza bat fzf lazygit yazi hunk'

log()  { printf '[dotfiles] %s\n' "$*"; }
warn() { printf '[dotfiles] WARNING: %s\n' "$*" >&2; }

case $(uname -s) in
  Linux) ;;
  *) printf 'install.sh targets Linux only. On macOS run: make install\n' >&2; exit 1 ;;
esac

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

# Move an existing file or directory out of the way, mirroring its path under $BACKUP_DIR.
backup() {
  rel=${1#"$HOME"/}
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  mv "$1" "$BACKUP_DIR/$rel"
  log "moved existing $rel to $BACKUP_DIR/$rel"
}

# Symlink $HOME/$1 -> $SRC/$1, replacing stale links and backing up real files.
link() {
  rel=$1
  src="$SRC/$rel"
  dst="$HOME/$rel"
  if [ ! -e "$src" ]; then
    warn "skipping $rel: not present in the repo"
    return 0
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return 0
  fi
  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    backup "$dst"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  log "linked $rel"
}

# ---------------------------------------------------------------------------
# 1. preserve what the devpod already configured
# ---------------------------------------------------------------------------

# on-create appends `export GITHUB_API_TOKEN="$GH_TOKEN"` to ~/.zshrc before
# dotfiles are installed. ~/.zshrc from this repo sources ~/.local/zshrc, so the
# existing file is merged into that and then replaced by the symlink.
preserve_zshrc() {
  rc="$HOME/.zshrc"
  [ -f "$rc" ] && [ ! -L "$rc" ] || return 0
  local_rc="$HOME/.local/zshrc"
  mkdir -p "$HOME/.local"
  {
    printf '\n# --- merged from ~/.zshrc by dotfiles/install.sh (%s) ---\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    cat "$rc"
  } >> "$local_rc"
  rm -f "$rc"
  log "merged the existing ~/.zshrc into ~/.local/zshrc"
}

# on-create writes git identity, safe.directory, the gh credential helper and
# perf settings into ~/.gitconfig, and post-attach re-runs `gh auth setup-git`
# on every attach. Symlinking ~/.gitconfig would either drop those or make git
# write into this repo. Instead ~/.gitconfig stays a real file that includes the
# repo config first, so anything the devpod writes keeps precedence.
setup_gitconfig() {
  cfg="$HOME/.gitconfig"
  repo_cfg="$SRC/.gitconfig"
  if [ -L "$cfg" ]; then
    rm -f "$cfg"
  fi
  if ! git config --file "$cfg" --get-all include.path 2>/dev/null | grep -qxF -- "$repo_cfg"; then
    tmp=$(mktemp)
    {
      printf '# Shared config from the dotfiles repo. Settings below override it.\n'
      printf '[include]\n\tpath = %s\n\n' "$repo_cfg"
      [ -f "$cfg" ] && cat "$cfg"
    } > "$tmp"
    mv "$tmp" "$cfg"
    chmod 644 "$cfg"
    log "$HOME/.gitconfig now includes $repo_cfg"
  fi

  # Machine-local overrides, included last by the repo's .gitconfig.
  local_cfg="$HOME/.local/gitconfig"
  marker='# dotfiles/install.sh: linux overrides'
  if ! grep -qsF -- "$marker" "$local_cfg"; then
    mkdir -p "$HOME/.local"
    cat >> "$local_cfg" <<'GITCFG'
# dotfiles/install.sh: linux overrides (no GPG key, no macOS keychain, no kitty)
[commit]
	gpgsign = false
[gpg]
	program = gpg
[credential]
	helper =
	helper = !gh auth git-credential
[diff]
	tool = hunk
GITCFG
    log "wrote linux overrides to ~/.local/gitconfig"
  fi
}

# ---------------------------------------------------------------------------
# 3. tools
# ---------------------------------------------------------------------------

install_tools() {
  if [ "${DOTFILES_SKIP_TOOLS:-0}" = 1 ]; then
    log "skipping tool install (DOTFILES_SKIP_TOOLS=1)"
    return 0
  fi
  if ! command -v mise >/dev/null 2>&1; then
    warn "mise not found; install these yourself: $TOOLS"
    return 0
  fi
  # mise's GitHub-backed installs are rate limited without a token. The devpod
  # carries a valid GH_TOKEN; mise honours GITHUB_API_TOKEN above GITHUB_TOKEN.
  if [ -z "${GITHUB_API_TOKEN:-}" ] && [ -n "${GH_TOKEN:-}" ]; then
    export GITHUB_API_TOKEN="$GH_TOKEN"
  fi
  export MISE_YES=1
  failed=''
  for tool in $TOOLS; do
    if mise use --global "$tool@latest" >/dev/null 2>&1; then
      log "installed $tool ($(mise which "$tool" 2>/dev/null || echo 'via mise'))"
    else
      failed="$failed $tool"
    fi
  done
  if [ -n "$failed" ]; then
    warn "mise could not install:$failed (retry with: mise use --global <tool>@latest)"
  fi
}

install_zsh_abbr() {
  dir="$HOME/.local/share/zsh-abbr"
  [ -f "$dir/zsh-abbr.zsh" ] && return 0
  if [ "${DOTFILES_SKIP_TOOLS:-0}" = 1 ]; then
    return 0
  fi
  if git clone --quiet --depth 1 --branch v6 --recurse-submodules \
      https://github.com/olets/zsh-abbr "$dir" 2>/dev/null; then
    log "installed zsh-abbr to $dir"
  else
    warn "could not clone zsh-abbr; abbreviations will be unavailable"
  fi
}

# ---------------------------------------------------------------------------
# 4. neovim plugins
# ---------------------------------------------------------------------------

sync_nvim_plugins() {
  if [ "${DOTFILES_SKIP_NVIM_SYNC:-0}" = 1 ]; then
    return 0
  fi
  if ! command -v nvim >/dev/null 2>&1; then
    warn "nvim not found; skipping plugin install"
    return 0
  fi
  log "installing neovim plugins from lazy-lock.json (this can take a few minutes)"
  if timeout 900 nvim --headless '+Lazy! restore' +qa >/dev/null 2>&1; then
    log "neovim plugins installed"
  else
    warn "neovim plugin install did not finish; run :Lazy restore inside nvim"
  fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

log "installing from $DOTFILES_DIR into $HOME"

preserve_zshrc
for path in $LINKS; do
  link "$path"
done
setup_gitconfig
install_tools
install_zsh_abbr
sync_nvim_plugins

if [ -d "$BACKUP_DIR" ]; then
  log "replaced files were kept under $BACKUP_DIR"
fi
log "done. Open a new zsh (the devpod's default shell) to pick up the config."
