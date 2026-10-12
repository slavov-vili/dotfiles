#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/rofi" <<EOF
config.rasi
keybinds.rasi
widgets
scripts
themes
EOF

