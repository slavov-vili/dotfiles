#!/bin/sh

# This file only contains helper functions for other shell scripts in the repo



# TODO: add support for sudo items (see lightdm)
# Copies the files given as stdin to the directory given as argument, replacing
# destination files if they exist.
#
# Input:
# $1 = The destination directory
# Stdin = A newline-separated string which represents the names/mappings of items
# which should be copied.
#
# Example 1: Copy a file to a directory, keepings the same name.
# copy_items "$HOME/.config/nvim" <<EOF
# init.lua
# EOF
#
# Example 2: Copy a file to a directory, renaming it.
# copy_items "$HOME/.config/nvim" <<EOF
# my_init.lua:init.lua
# EOF
#
# Example 3: Copy a files to a directory using globs.
# copy_items "$HOME/Scripts" <<EOF
# *.sh
# EOF
#
# Example 4: Copy a file to a directory which requires sudo rights.
# copy_items "/etc" 1 <<EOF
# init.lua
# EOF
copy_items() {
  _src_dir="$(pwd)"
  _dest_dir="$1"
  _needs_sudo=${2:-0}

  _mkdir_cmd="mkdir -p \"$_dest_dir\""
  if [ 1 -eq $_needs_sudo ]; then
    _mkdir_cmd="sudo $_mkdir_cmd"
  fi
  eval "$_mkdir_cmd"

  while IFS= read -r _mapping || [ -n "$_mapping" ]; do

    _src=''
    _dest=''
    case "$_mapping" in
        *:*)
            _src="${_mapping%%:*}"
            _dest="${_mapping#*:}"
            ;;
        *)
            _src="$_mapping"
            _dest="$_mapping"
            ;;
    esac

    _dest_path="$_dest_dir/$_dest"

    echo "Looking for entries of '$_src'"
    for _src_item in $(find . -mindepth 1 -name "$_src")
    do
      if [ ! -e "$_src_item" ]; then
        echo "Error: Source '$_src_item' does not exist, skipping!" >&2
        continue
      fi

      _type="file"
      _cp_cmd="cp --verbose --force --remove-destination"
      if [ -d "$_src_item" ]; then
        _type="directory"
        _cp_cmd="$_cp_cmd --recursive"
      fi

      if [ 1 -eq $_needs_sudo ]; then
        _cp_cmd="sudo $_cp_cmd"
      fi
      # echo "Copying $_type: $_src_item -> $_dest_path"
      eval "$_cp_cmd -- $_src_item $_dest_path"
      echo "Done."
      echo ""
    done
  done
}



# Determines the name of a file given a profile
# Returns:
# <filename>_<profile>.<extension> If a file with the profile as suffix exists
# <filename>.<extension> If no profile-specific version of the file exists
get_filename_for_profile() {
  _filename_base="$1"
  _file_extension="$2"
  _profile="$3"

  filename="${_filename_base}_${_profile}.${_file_extension}"
  if [ ! -f "$filename" ]; then
    filename="${_filename_base}.${_file_extension}"
  fi
  echo "$filename"
}

