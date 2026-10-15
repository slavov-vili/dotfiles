#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/picom" <<EOF
picom.conf
EOF
