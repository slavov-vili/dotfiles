#!/bin/sh

# Import/Source
. "./commons.sh"

_dir="$(pwd)"
_profile="$1"

_projects_file=$(get_filename_for_profile "projects_to_setup" "txt" "$_profile")

while IFS= read -r _line || [ -n "$_line" ]; do
  # Skip empty lines or commented lines (starting with #)
  case "$_line" in
    ""|\#*) continue ;;
  esac

  if [ -d "$_line" ]; then
    echo "Setting up $_line:"
    cd "$_line"

    if [ -f 'setup.sh' ]; then
      sh ./setup.sh
    else
      echo "Warning: No setup.sh found in '$_line'!"
    fi

    # TODO: call extend.sh script if exists to enable stuff

    cd $_dir
  else
    echo "Warning: Directory '$_line' does NOT exist!"
  fi
done < $_projects_file

