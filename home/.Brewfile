# ------------------------------------------------------------------------------
# Core
# ------------------------------------------------------------------------------
brew 'stow'         # Organize software neatly under a single directory tree
brew 'tmux'         # My choice of terminal multiplexer
brew 'eza'          # Modern ls replacement
brew 'entr'         # Run command on filechange
brew 'starship'     # The cross-shell prompt for astronauts; https://starship.rs
brew 'neovim'       # , args: %w[HEAD]
brew 'bat'          # Clone of cat(1) with syntax highlighting and Git integration
brew 'git'
brew 'git-lfs'
brew 'hunk'
brew 'lazygit'
brew 'lazydocker'
brew 'ctags'
brew 'fzf'
brew 'zoxide'
brew 'ag'
brew 'ripgrep'
brew 'jq'
brew 'yq'
brew 'rsync'
brew 'htop'
brew 'httpie'
brew 'imagemagick', link: true
brew 'yazi'
brew 'gh'
tap 'olets/tap'
brew 'olets/tap/zsh-abbr'
brew 'opencode'

brew 'llm'  # Access to multiple LLMs from the terminal with logging and more...
brew 'glow' # Markdown rendering in the terminal
brew 'herdr'

cask 'raycast'

# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------
brew 'mise'
brew 'bash-language-server'
brew 'bats'
brew 'go'
brew 'lua-language-server'
brew 'shellcheck'
brew 'marksman'
brew 'yaml-language-server'

# ------------------------------------------------------------------------------
# Apps for work
# ------------------------------------------------------------------------------
cask 'kitty'
cask 'ghostty'
# tap 'derailed/k9s'
brew 'k9s'
# cask 'google-cloud-sdk'

# ------------------------------------------------------------------------------
# Fonts
# ------------------------------------------------------------------------------
cask 'font-victor-mono-nerd-font'

# ------------------------------------------------------------------------------
# GPG Signing
# ------------------------------------------------------------------------------
# GPG commit signing setup: create a key in GPG Keychain, get its ID via
# `gpg --list-secret-keys --keyid-format=long`, set it with
# `git config --global user.signingkey <ID>`, then point gpg-agent at this:
# echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
# gpgconf --kill gpg-agent
brew 'pinentry-mac'
cask 'gpg-suite'
