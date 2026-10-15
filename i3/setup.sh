#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/i3" <<EOF
config
*.conf
EOF

