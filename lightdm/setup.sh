#!/bin/sh

. "../commons.sh"

copy_items "$HOME" <<EOF
xprofile:.xprofile
EOF
sudo cp --verbose --force --remove-destination $DIR/lightdm.conf /etc/lightdm/lightdm.conf
