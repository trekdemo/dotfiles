# Read by EVERY zsh: interactive, non-interactive, login, script.
#
# mise is activated in ~/.config/zsh/conf.d/mise.zsh, which only ~/.zshrc sources.
# Without the shims here, anything that is not an interactive shell — a `zsh -c`
# from another program, the Claude Code Bash tool, a hook — resolves `ruby` to
# /usr/bin/ruby, the macOS 2.6 stub. `mise activate` still runs later in
# interactive shells and prepends the real install dirs, shadowing the shims.

[ -f "$HOME/.config/zsh/tools-path.zsh" ] && source "$HOME/.config/zsh/tools-path.zsh"
