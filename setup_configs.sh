#!/bin/sh

# Import/Source
. "./commons.sh"

# TODO: take an argument to determine the profile
#       if a profile-specific file exists, then take that
#       else - take the one without the profile

dir="$(pwd)"
profile="$1"

projects_file=$(get_filename_for_profile "projects_to_setup" "txt" "$profile")

while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines or commented lines (starting with #)
  case "$line" in
    ""|\#*) continue ;;
  esac

  if [ -d "$line" ]; then
    echo "Setting up $line:"
    cd "$line"

    if [ -f 'setup.sh' ]; then
      echo sh ./setup.sh
    else
      echo "Warning: No setup.sh found in '$line'!"
    fi

    cd $dir
  else
    echo "Warning: Directory '$line' does NOT exist!"
  fi
done < $projects_file

