#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/polybar" <<EOF
config.ini
EOF

