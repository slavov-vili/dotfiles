#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config" <<EOF
mimeapps.list
EOF
