#!/bin/sh

# This file only contains helper functions for other shell scripts in the repo



copy_items() {
  # TODO: add support for globs in patterns?
  # TODO: write documentation
  #       takes a destination and a mapping of names and overwrites the targets
  _src_dir="$(pwd)"
  _dest_dir="$1"

  mkdir -p "$_dest_dir"

  while IFS= read -r _mapping || [ -n "$_mapping" ]; do
    # TODO: add glob support
    # for f in $(find .. -wholename "../*/*.md"); do echo $f; done
    # TODO: do I even need src_path? removing it would let me pass absolute paths as well
#
    # Source (everything before the first colon)
    _src="${_mapping%%:*}"
    _src_path="$_src_dir/$_src"

    # Destination (everything after the first colon)
    _dest="${_mapping#*:}"
    _dest_path="$_dest_dir/$_dest"

    if [ -z "$_dest_path" ]; then
      _dest="$_src_path"
    fi

    if [ ! -e "$_src_path" ]; then
      echo "Error: Source '$_src_path' does not exist, skipping!" >&2
      continue
    fi

    _type="file"
    _cp_args="cp --verbose --force --remove-destination"
    if [ -d "$_src_path" ]; then
      _type="directory"
      _cp_args="$_cp_args --recursive"
    fi

    echo "Copying $_type: $_src_path -> $_dest_path"
    echo cp "$_cp_args" -- "$_src_path" "$_dest_path"
    echo ""
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

