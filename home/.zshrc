# Loading order - alphabetical
# https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# +----------------+-----------+-----------+------+
# |                |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# | /etc/zshenv    |    A      |    A      |  A   |
# +----------------+-----------+-----------+------+
# | ~/.zshenv      |    B      |    B      |  B   |
# +----------------+-----------+-----------+------+
# | /etc/zprofile  |    C      |           |      |
# +----------------+-----------+-----------+------+
# | ~/.zprofile    |    D      |           |      |
# +----------------+-----------+-----------+------+
# | /etc/zshrc     |    E      |    C      |      |
# +----------------+-----------+-----------+------+
# | ~/.zshrc       |    F      |    D      |      |
# +----------------+-----------+-----------+------+
# | /etc/zlogin    |    G      |           |      |
# +----------------+-----------+-----------+------+
# | ~/.zlogin      |    H      |           |      |
# +----------------+-----------+-----------+------+
# ~~~~~~~~~~~~~~~~~~~~~~~ 8< ~~~~~~~~~~~~~~~~~~~~~~
# +----------------+-----------+-----------+------+
# | ~/.zlogout     |    I      |           |      |
# +----------------+-----------+-----------+------+
# | /etc/zlogout   |    J      |           |      |
# +----------------+-----------+-----------+------+

# zmodload zsh/zprof

setopt SHARE_HISTORY             # Share history between all sessions.

export HISTFILE=~/.cache/zsh/history
export BROWSER=open
export XDG_CONFIG_HOME="$HOME/.config/"
export TZ="/usr/share/zoneinfo/Europe/Amsterdam"
export LANG="en_US.utf-8"
export LC_ALL="en_US.utf-8"

export PATH="/opt/homebrew/bin:$PATH"

[ -d "/usr/local/opt/llvm/bin" ] && export PATH="/usr/local/opt/llvm/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/go/bin" ]     && export PATH="$HOME/go/bin:$PATH"
[ -d "$HOME/bin" ]        && export PATH="$HOME/bin:$PATH"
# Add Python bin paths to the PATH
# $HOME/Library/Python/*/bin
export PATH="$HOME/Library/Python/*/bin:$PATH"

# Add executables from projects within git repositories
export PATH=".git/safe/../../node_modules/.bin/:$PATH"
export PATH=".git/safe/../../bin:$PATH"

# Load config files
for rc in $(ls "$HOME/.config/zsh/conf.d/"); do
  # echo "Loading $rc"
  if [ -f "$HOME/.config/zsh/conf.d/$rc" ]; then
    source "$HOME/.config/zsh/conf.d/$rc"
  fi
done
[ -f "$HOME/.local/zshrc" ] && source "$HOME/.local/zshrc"

# Setup prompt https://starship.rs/config/
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"
# zprof

export NVM_DIR="$HOME/.config//nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
