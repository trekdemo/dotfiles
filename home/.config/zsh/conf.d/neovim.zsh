#!/bin/sh

export EDITOR="nvim"

if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="$EDITOR"
else
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
fi
