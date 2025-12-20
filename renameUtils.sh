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

extractAfter(){
        target=$1;
        n=$((${#target} - 1));
        i=$n;
        result="";
        index=-1;

        while [ $i -ge 0 ]; do
                value=${target:$i:1};
                if [[ "$value" == "." ]]; then
                        index=$i;
                        result=${target:$((i+1)):n};
                        break;
                fi
                ((i--));
        done

        echo "$result";

        #goal here is to find the '.' then extract everything after it.
        #only extract if the file has an extension

        #kind of redundant to search the string twice for the '.', just search is found record the extension type
        #to ensure we only get the extension and reduce search time read the string backwards.
}

rename(){
        #make more reusable by allowing for naming options like passing in the S and or E
        local oldName=$1;
        seasonNum=$2;
        epNum=$3;
        newName="";#missing this may have been the issue.
        extension="";#no extension leave as is
        exten=$(extractAfter $oldName);
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

        if [[ ${#exten} -eq 0 ]]; then
                newName=$oldName;
        else
                newName="${seasonNum}${epNum}.${extension}";
        fi

        echo "$newName";
        mv -- "$oldName" "$newName";
}

#will need to extract the episode name from the file before renaming.

renameAll(){
        dir=$1;#is expecting the season number to be passed no the directory.
        files=( * );
        #seasonNum=$(numExtract $dir); #is almost working.
        echo "season num  $dir";

        for f in "${files[@]}"; do
                #echo "file: $f";
                #TODO grab num from directory and from file name then rename file.
                epNum=$(numExtract $f);
                newNme=$(rename $f $dir $epNum);
                echo "Old: $f, new: $newNme";
        done
}
