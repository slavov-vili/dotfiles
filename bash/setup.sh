#!/bin/sh

. "../commons.sh"

_profile="$1"

copy_items "$HOME" "$_profile" <<EOF
bash_profile:.bash_profile
bashrc:.bashrc
inputrc:.inputrc
EOF
