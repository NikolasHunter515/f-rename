#!/bin/bash
source ./renameUtils.sh;

#TODO add safe guard for flags, need to handle unexpected usage.
VERSION="1.1.1";
param="";
param2="false"; #added a rename safety
param3="false"; #zero flag
mode="";

# parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)
            echo "Frename version $VERSION"
            exit 0
            ;;
        -t)
            param2="true"
            ;;
        -z)
            param3="true"
            ;;
        -uS)
            mode="unsorted"
            ;;
        -sS)
            mode="sorted"
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            # first non-flag argument = directory
            if [[ -z "$param" ]]; then
                param="$1"
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
            ;;
    esac
    shift
done

#check before changing dir.
if [[ -z "$param" ]]; then
    echo "Usage: frename [options] <directory>"
    exit 1
fi

cd "$param" || { echo "Invalid directory: $param"; exit 1; }

p1=$(numExtract "$param");

case "$mode" in
    unsorted)
        echo "Unsorted rename";
        unsorted_rename "$p1" "$param3" "$param2"
        exit 1
        ;;
    sorted)
        echo "Sorted rename";
        renameAll "$p1" "$param2" "$param3" "true"
        exit 1
        ;;
esac

path="tvshows/sopranos/season 1";
pwd
echo "Numeric extract rename";

renameAll $p1 "$param2" "$param3" "false";
