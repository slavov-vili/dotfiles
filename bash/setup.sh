#!/bin/sh

. "../commons.sh"

copy_items "$HOME" <<EOF
bash_profile:.bash_profile
bashrc:.bashrc
inputrc:.inputrc
EOF
