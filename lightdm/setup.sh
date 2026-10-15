#!/bin/sh

. "../commons.sh"

copy_items "$HOME" <<EOF
xprofile:.xprofile
EOF

copy_items "/etc/lightdm" 1 <<EOF
lightdm.conf
EOF
