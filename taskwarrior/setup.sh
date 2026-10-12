#!/bin/sh

. "../commons.sh"

copy_items "$HOME" <<EOF
taskrc:.taskrc
EOF

echo "!!! REMINDER: Don't forget to recover your backed up data files."
echo "    Data files go in ' $HOME/.task'."

