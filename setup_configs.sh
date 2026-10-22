#!/bin/sh

# Import/Source
. "./commons.sh"

_dir="$(pwd)"
_profile="$1"

_projects_file=$(get_filename_for_profile "projects_to_setup.txt" "$_profile")

while IFS= read -r _line || [ -n "$_line" ]; do
  # Skip empty lines or commented lines (starting with #)
  case "$_line" in
    ""|\#*) continue ;;
  esac

  if [ -d "$_line" ]; then
    echo "Setting up $_line:"
    cd "$_line"

    _setup_script=$(get_filename_for_profile "setup.sh" "$_profile")
    if [ -f "$_setup_script" ]; then
      sh "./$_setup_script"
    else
      echo "Warning: No setup script found in '$_line'!"
    fi

    cd $_dir
  else
    echo "Warning: Directory '$_line' does NOT exist!"
  fi
done < "$_projects_file"

