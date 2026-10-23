# This is the home of the configuration files of all tools that I have ever writjen and deemed useful.



# TODOs
- [ ] Add rofi configuration for i3 (dmenu-style)
- [ ] Add examples of how different tools can be customized: bash, git, i3 includes?
- [ ] Prevent scripts from blindly overwriting stuff
    * Option 1: Create backups before copying files
    * Option 2: Add support for fetch (from dest) to keep the files here up to date
- [ ] Move tool-specific executable files in some bin/ folder? Just .config/ seems weird.



# Setup script mechanism
This is a set of shell scripts, which makes it easier to:
1. Configure multiple tools at once.
1. Configure tools on different machines (with different configurations).


## Configuring a single tool
Each tool should contain a setup script, which describes:
- Where the configuration of the tool should be copied (e.g. `$HOME/.gitconfig`).
- Which files and directories should be copied as part of the configuration.


## Configuring multiple tools at once
Since it's annoying to manually run each setup script, there is a way to automatically run
multiple setup scripts at once.

1. Main entrypoint: `setup_configs.sh`
2. Treats each line of the file `projects_to_setup.txt` as the name of a tool which should be
installed.
    - Lines starting with `#` are treated as comments and ignored.
3. For each tool: goes to it's directory and executes its setup script.


## Configuring tools for different machines
Sometimes you want to be able to have different configurations for different machines. For example you have extra aliases and configurations for work, or you use X11, i3 and nvim on one machine and Wayland, Hyperland and nvim on another.

This is why the setup scripts can take as an argument a __profile__, which is used to identify
specific files. Each profile-specific file should be of the form `<original_name>_<profile>.<extension>`.

### Machine-specific sets of tools
1. Create a file `projects_to_setup_<profile>.txt`, where __profile__ is the chosen name for your profile (e.g. __work__).
1. Enter the tools that you want to install for that profile.
1. Pass the profile name to the `setup_configs.sh` when ready.
    - The script should only set up the tools specified in the new file.

### Machine-specific config files
1. Create a config file with the profile name as suffix (e.g. `tmux_work.conf`).
1. Fill in the new config file with your desired configuration.
1. Pass the profile name to the `setup.sh` script when ready.
    - The script should only set up the profile-specific file.

### Machine-specific setup scripts
1. Choose a tool for which you want a custom setup script.
1. Create a `setup.sh` script with the profile name as suffix (e.g. `setup_work.sh`).
1. Implement whatever setup logic you want in the new script.
1. Run the new setup script
    - Option 1: Run the script directly
    - Option 2: Pass the profile name to the `setup_configs.sh` script, it should automatically recognize, that a profile-specific setup script exists for the tool.

### NOTES
- Currently, not all setup scripts support profiles
    * i.e. the setup script doesn't pass the `profile` parameter to its function calls
    * Why? because I've been too lazy to add it to every single file.
    * Eventually they will be added as I start needing more tools, but for now this is life.


## Common functions
I've tried to extract common script functions into a the file `commons.sh`, which is used by all
other scripts.

### `get_filename_for_profile`
1. What?
    - Figures out the name of a given file, if it were to be installed using a given profile
    - Basically: if a profile-specific file exists, prefer that.
1. Parameters:
    - $1 = The original filename (without profile suffix)
    - $2 = The profile which should be applied to the filename
1. Notes
    - The function automatically takes apart the filename and can handle both files with and without extensions.

### `copy_items`
1. What?
    - Copies the given files and directories into the specified target directory
    - NOTE: Currently the function removes the complete target directory and copies the files into it. So be careful to not lose your configurations!
1. Parameters:
    - $1 = The destination directory (directory where the source items should be copied).
    - $2 = The active profile (used to identify file names).
    - $3 = Whether to use sudo when copying (0|1).
    - Sdtin = A newline-separated string which represents the names/mappings of items which should be copied.
1. Notes
    - You do NOT need to provide all parameters.
    - If a filename doesn't exist, it is simply skipped.
    - If an input line is in the form of a mapping (`<src_name>:<dest_name>`), the file is copied under the `<dest_name>` name.
    - If an input line contains a glob pattern (e.g. `*` wildcards), all files which match the pattern are copied. The function just uses `find` to get its items.
    - Using a glob pattern AND a mapping line will copy each file matched by the glob to the same destination file, overwriting it each time.
