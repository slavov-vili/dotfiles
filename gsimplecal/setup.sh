#!/bin/sh

. "../commons.sh"

_profile="$1"

copy_items "$HOME/.config/gsimplecal" "$_profile" <<EOF
config
EOF
