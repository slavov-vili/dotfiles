#!/bin/sh

# This file only contains helper functions for other shell scripts in the repo



# Copies the files given as stdin to the directory given as argument, replacing
# destination files if they exist.
#
# Input:
# $1 = The destination directory
# $2 = A profile name (used to identify profile-specific files)
# $3 = 0|1: Whether to use sudo when copying
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
#
# Example 5: Copy a profile-specific file instead of the profile-less one.
# Result: copies my_init_work.lua to the target directory as init.lua
# copy_items "$HOME/.config/nvim" "work" <<EOF
# my_init.lua:init.lua
# EOF
copy_items() {
  _src_dir="$(pwd)"
  _dest_dir="$1"
  _profile="$2"
  _needs_sudo=${3:-0}

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
            _dest=''
            ;;
    esac

    echo "Looking for entries of '$_src'"
    for _src_item_orig in $(find . -mindepth 1 -name "$_src")
    do
      _src_item=$(get_filename_for_profile "$_src_item_orig" "$_profile")
      if [ ! -e "$_src_item" ]; then
        _src_item=$(basename "$_src_item")
      fi
      # echo "Source: '$_src_item'"

      if [ ! -e "$_src_item" ]; then
        echo "Warning: Source '$_src_item' does not exist, skipping!" >&2
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

      _dest_path="$_dest_dir"
      if [ $_type = "file" ]; then
        _dest_item="$_dest"
        if [ -z "$_dest" ]; then
          _dest_item="$_src_item_orig"
        fi
        _dest_path="$_dest_dir/$_dest_item"
      fi
      # echo "Destination: $_dest_path"

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
  _filename_orig="$1"
  _profile="$2"

  if [ -z "$_profile" ]; then
    echo "$_filename_orig"
    return 0
  fi

  case "$_filename_orig" in
      +.*)
          _filename_base="${_filename_orig%.*}"
          _file_extension="${_filename_orig##*.}"
          ;;
      *)
          _filename_base="$_filename_orig"
          _file_extension=""
          ;;
  esac
  # echo "Filename base: $_filename_base"
  # echo "File extension: $_file_extension"

  _filename_result="${_filename_base}_${_profile}"
  if [ ! -z "$_file_extension" ]; then
    _filename_result="${_filename_result}.${_file_extension}"
  fi

  if [ ! -f "$_filename_result" ]; then
    _filename_result="$_filename_orig"
  fi
  echo "$_filename_result"
  return 0
}

