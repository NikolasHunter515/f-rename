# f-rename

The file rename autmates the task of renaming files in a directory that do not follow the desired standard of the system.
The current version of the script only supports the season episode naming convention. And features sorted and unsorted renaming, if neither are selected orginal standard rename will be executed.

# Usage:
Simply write "bash frename "<directory path>"" and the script does the rest. The folder path must be passed as string(as of Dec-2025). When running script is it advised the script be ran with the test flag first.

Inputs-  
  1. Path to target folder, or "-v"/"--version" to check version.
  2. Test flag "-t" disables file renaming.
  3. Zero flag "-z" used to start count from 0, starts at 1 by default.
  4. Usorted rename flag "-uS"
  5. Sorted rename flag "-sS"
  6. Directory path "<>" assume starting from current folder of script.

#Install:
Only the frename, and utilities files are needed for this to work. Just add the files in the root directory of all possible directories that are required to follow the aforementioned format.
Global access is currently in the works.
