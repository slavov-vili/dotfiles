#!/bin/sh

. "../commons.sh"

_profile="$1"

copy_items "$HOME/.config/i3" "$_profile" <<EOF
config
*.conf
EOF

