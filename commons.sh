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
# Example 1: Copy a file to a directory, keeping the same name.
# copy_items "$HOME/.config/nvim" <<EOF
# init.lua
# EOF
#
# Example 2: Copy a file to a directory, renaming it.
# copy_items "$HOME/.config/nvim" <<EOF
# my_init.lua:init.lua
# EOF
#
# Example 3: Copy files to a directory using globs.
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
  _src_dir=${1:-"$(pwd)"}
  _dest_dir="$HOME/.config/$(basename $(pwd))"
  _profile="$2"
  _reversed=${3:-0}

  _src_dir_prefix="src_dir: "
  _dest_dir_prefix="dest_dir: "

  if [ 1 -eq $_reversed ]; then
    # Swap default values
    _temp="$_src_dir"
    _src_dir="$_dest_dir"
    _dest_dir="$_temp"

    # Swap future values
    _temp="$_src_dir_prefix"
    _src_dir_prefix="$_dest_dir_prefix"
    _dest_dir_prefix="$_temp"
  fi

  while IFS= read -r _file_mapping || [ -n "$_file_mapping" ]; do
    # Default case: line = filename
    _src_pattern="$_file_mapping"
    # Dest might be changed later in case of lines which contain globs
    _dest_pattern=''

    case "$_file_mapping" in
      "$_src_dir_prefix"*)
        _src_dir="$(get_dir_from_mapping "$_src_dir_prefix" "$_file_mapping")"
        if [ ! -e "$_src_dir" ]; then
          echo "Source directory '$_src_dir' doesn't exist. Quitting!"
          exit 1
        fi
        continue
        ;;

      "$_dest_dir_prefix"*)
        _dest_dir="$(get_dir_from_mapping "$_dest_dir_prefix" "$_file_mapping")"
        make_dir "$_dest_dir"
        echo "Ensured destination directory '$_dest_dir' exists."
        continue
        ;;

      # Line = mapping "src_name:dest_name"
      *:*)
        _src_pattern="${_file_mapping%%:*}"
        _dest_pattern="${_file_mapping#*:}"
        ;;
    esac

    # Allows lines with globs
    echo "Looking for entries of '$_src_pattern' in '$_src_dir/'"
    # mindepth disregards the dir itself
    for _src_item_orig in $(find "$_src_dir" -mindepth 1 -name "$_src_pattern")
    do
      # Handle profile-specific items
      _src_item="$(get_filename_for_profile "$_src_item_orig" "$_profile")"
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

      _dest_path="$_dest_dir"
      if [ $_type = "file" ]; then
        # Not mapping, so take original filename
        if [ -z "$_dest_pattern" ]; then
          _dest_pattern="$(basename "$_src_item_orig")"
        fi

        _dest_path="$_dest_dir/$_dest_pattern"
      fi

      _cp_cmd="$(get_command_for_filepath "$_cp_cmd" "$_dest_path")"
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

  # echo "Filename original: $_filename_orig"
  case "$_filename_orig" in
      ?*.*)
          # echo "Has extension!"
          _filename_base="${_filename_orig%.*}"
          _file_extension="${_filename_orig##*.}"
          ;;
      *)
          # echo "NO extension!"
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



get_dir_from_mapping() {
  _dir_prefix="$1"
  _mapping_line="$2"

  _resolved_dir="$(echo "$_mapping_line" | cut -c1-${#_dir_prefix} --complement)"
  eval echo "$_resolved_dir"
}



make_dir() {
  _dir_to_make="$1"
  _mkdir_cmd="$(get_command_for_filepath "mkdir -p \"$_dir_to_make\"")"
  eval "$_mkdir_cmd"
}



get_command_for_filepath() {
  _cmd="$1"
  _filepath="$2"

  # Check if needs sudo
  case "$_filepath" in
        /home*)
            echo "$_cmd"
            ;;
        /*)
            echo "sudo $_cmd"
            ;;
        *)
            echo "$_cmd"
            ;;
    esac
}
