#!/bin/bash

DIR=$(pwd)
VIM_DIR="$HOME/.config/nvim/"
mkdir $VIM_DIR

cp --verbose --force --remove-destination $DIR/init.lua  $VIM_DIR/init.lua

cp --verbose --force --remove-destination --recursive $DIR/colors  $VIM_DIR/
cp --verbose --force --remove-destination --recursive $DIR/plugin  $VIM_DIR/


