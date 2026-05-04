#!/bin/sh

export EDITOR="nvim"

export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"
if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
  # Kept for cases where listen address is unset
  export VISUAL="$EDITOR"
else
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
fi
