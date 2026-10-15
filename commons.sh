#!/bin/sh

# This file only contains helper functions for other shell scripts in the repo



# TODO: add support for sudo items (see lightdm)
copy_items() {
  # TODO: write documentation
  #       takes a destination and a mapping of names and overwrites the targets
  _src_dir="$(pwd)"
  _dest_dir="$1"

  mkdir -p "$_dest_dir"

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

    _dest_path="$_dest_dir/$_dest"

    echo "Looking for entries of '$_src'"
    for _src_item in $(find . -mindepth 1 -name "$_src")
    do
      if [ ! -e "$_src_item" ]; then
        echo "Error: Source '$_src_item' does not exist, skipping!" >&2
        continue
      fi

      _type="file"
      _cp_args="--verbose --force --remove-destination"
      if [ -d "$_src_item" ]; then
        _type="directory"
        _cp_args="$_cp_args --recursive"
      fi

      # echo "Copying $_type: $_src_item -> $_dest_path"
      eval "cp $_cp_args -- $_src_item $_dest_path"
      echo "Done."
      echo ""
    done
  done
}

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

