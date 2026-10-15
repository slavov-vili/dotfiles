#!/bin/sh

. "../commons.sh"

copy_items "$HOME/.config/openbox" <<EOF
rc.xml
autostart
menu.xml
EOF
