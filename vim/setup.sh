#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/nvim" <<EOF
init.lua
colors
plugin
EOF

