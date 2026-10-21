#!/bin/sh

. "../commons.sh"

_profile="$1"

copy_items "$HOME" "$_profile" <<EOF
gitconfig:.gitconfig
EOF

