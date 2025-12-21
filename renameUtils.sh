#!/bin/bash
numExtract() {
        # want to extract a continous number
        # finds the first number in string and extracts it.
        # extract number from string until end of string or non numerical char
        str=$1;
        i=0;
        result="";

        while [ $i -le ${#str} ]; do
                value=${str:$i:1};
                if [[ "$value" =~ [1-9] ]]; then
                        result="${result}${value}";
                else
                        if [[ ${#result} > 0 ]]; then
                                break;
                        fi
                fi

                ((i++));
        done
        echo "$result";
}

extractAfter() {
    local target="$1"
    # remove all up to the last dot
    local ext="${target##*.}"
    # if no dot was found, ext = full filename → treat as no extension
    if [[ "$ext" == "$target" ]]; then
        ext=""
    fi
    echo "$ext"
}

rename_file(){
        #make more reusable by allowing for naming options like passing in the S and or E
        local oldName=$1;
        seasonNum=$2;
        epNum=$3;
        testFlag=$4;
        newName="";#missing this may have been the issue.
        extension="";#no extension leave as is
        exten=$(extractAfter "$oldName");
        if [[ ${#exten} -gt 0  ]]; then
                extension=$exten;
        fi


        if [[ $seasonNum -lt 10 ]]; then
                seasonNum="S0${seasonNum}";
        else
                seasonNum="S${seasonNum}";
        fi

        if [[ $epNum -lt 10 ]]; then
                epNum="E0${epNum}";
        else
                epNum="E${epNum}";
        fi

        if [[ ${#extension} -eq 0 ]]; then
                newName=$oldName;
        else
                newName="${seasonNum}${epNum}.${extension}";
        fi

        if [[ "$testFlag" == "true" ]]; then
                mv -- "$oldName" "$newName";
        fi

        echo "$newName";
}

#will need to extract the episode name from the file before renaming.

renameAll(){
        dir=$1;#is expecting the season number to be passed no the directory.
        test=$2
        files=( * );
        #seasonNum=$(numExtract $dir); #is almost working.
        echo "season num  $dir";

        for f in "${files[@]}"; do
                #echo "file: $f";
                #TODO grab num from directory and from file name then rename file.
                epNum=$(numExtract "$f");
                newNme=$(rename_file "$f" "$dir" "$epNum" "$test");
                echo "Old: $f, new: $newNme";
        done
}
