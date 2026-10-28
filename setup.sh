#!/bin/sh

. "./commons.sh"

_dir="$(pwd)"
_mode="$1"
_profile="$2"

_reversed=0
if [ "fetch" = "$_mode" ]; then
  _reversed=1
fi

_projects_file=$(get_filename_for_profile "projects_to_setup.txt" "$_profile")

while IFS= read -r _line || [ -n "$_line" ]; do
  case "$_line" in
    # Skip empty or commented lines
    ""|\#*) continue ;;
  esac

  if [ -d "$_line" ]; then
    echo "Processing $_line:"
    cd "$_line"

    _setup_script=$(get_filename_for_profile "setup.sh" "$_profile")
    if [ -f "$_setup_script" ]; then
      echo "Executing custom setup script $_setup_script"
      sh "./$_setup_script"
    else
      _file_mapping_txt=$(get_filename_for_profile "file_mapping.txt" "$_profile")
      copy_items . "$_profile" $_reversed < "$_file_mapping_txt"
    fi

    cd "$_dir"
  else
    echo "Warning: Directory '$_line' does NOT exist!"
  fi
done < "$_projects_file"

