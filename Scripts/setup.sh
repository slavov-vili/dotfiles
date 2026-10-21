#!/bin/sh

. "../commons.sh"

_profile="$1"

copy_items "$HOME/Scripts" "$_profile" <<EOF
*.sh
EOF

