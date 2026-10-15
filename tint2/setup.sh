#!/bin/sh

. "../commons.sh"

# start_menu.desktop
copy_items "$HOME/.config/tint2" <<EOF
tint2rc_custom_adapta:tint2rc
EOF

copy_items "$HOME/.icons/tint2" <<EOF
icons
EOF
