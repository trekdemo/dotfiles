#!/usr/bin/env bash

set -o nounset # Treat unset variables as an error

selected=$(curl --silent https://cht.sh/:list | fzf --print-query --prompt 'cht.sh/' | tail -n1 | tr ' ' '+')

curl --silent "https://cht.sh/${selected}" | less --raw-control-chars
