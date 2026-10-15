#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/tmux" <<EOF
tmux.conf
EOF
