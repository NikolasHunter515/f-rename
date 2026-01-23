#!/bin/bash
source ./renameUtils.sh;

#TODO add safe guard for flags, need to handle unexpected usage.
VERSION="1.1.1";
param=$1;
param2="false"; #added a rename safety
param3="false"; #zero flag

if [[ "$1" == "--version" || "$1" == "-v" ]]; then
        echo "Frename version $VERSION";
        exit 0;
fi

if [[ "$2" == "-t" ]]; then
        param2="true";
fi

if [[ "$3" == "-z" ]]; then
        param3="true";
fi

cd "$param" || { echo "Invalid directory: $param"; exit 1; }

p1=$(numExtract "$param");
cd "$param";

#unsorted rename
if [[ "$4" == "-uS" ]]; then
        unsorted_rename $p1 "$param3" "$param2";
        exit 0;
fi

#sorted rename or rename all.
if [[ "$4" == "-sS" ]]; then
        renameAll $p1 "$param2" "$param3" "true";
        exit 0;
fi

path="tvshows/sopranos/season 1";
pwd
echo "working";

renameAll $p1 "$param2" "$param3" "false";
