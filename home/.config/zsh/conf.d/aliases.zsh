if (( $+commands[eza] )); then
  list="eza --icons=auto --hyperlink --group-directories-first"
  alias l="${list}"
  alias ll="${list} --long --no-time --no-user --no-permissions --octal-permissions"
  alias la="${list} --long --no-time --no-user --no-permissions --octal-permissions --all"
fi

(( $+commands[bat] ))    && alias cat=bat
(( $+commands[zoxide] )) && alias cd=z

alias hmm='docker run --rm -it -v $(pwd):/app/ hmm'
