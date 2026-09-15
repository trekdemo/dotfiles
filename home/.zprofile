# Homebrew is macOS only; Linux boxes (devpods) have no /opt/homebrew.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# /etc/zprofile ran path_helper before this file and moved /usr/bin ahead of the
# mise shims that ~/.zshenv put first. Re-prepend them.
[ -f "$HOME/.config/zsh/tools-path.zsh" ] && source "$HOME/.config/zsh/tools-path.zsh"

# Ruby debug server, by default, on this port
export RUBY_DEBUG_PORT=38698
