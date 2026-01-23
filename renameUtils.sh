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
                if [[ "$value" =~ [0-9] ]]; then
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

        #issue here cannot get 0 in value without changing this.
        #could just get rid of it to handle 
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

        if [[ "$testFlag" == "false" ]]; then #only change if the safety is off.
                mv -- "$oldName" "$newName";
        fi

        echo "$newName";
}

sorted_rename(){
        season=$1;
        zero=$2;

        epCount=1;
        if [[ $zero -eq 1 ]]; then
                epCount=0;
        fi
}

unsorted_rename(){
        season=$1;
        zero=$2;
        dryRun=$3;
        
        minEp=999999;
        bias=1; #1 assumes staring from 1

        if [[ "$zero" == "true" ]]; then
                bias=0;
        fi

        #plan
        #1.loop to find smallest value while renaming.
        #2.rename based of difference between min value.

        for f in "${files[@]}"; do
                epNum=$(numExtract "$f");
                if [[ $epNum -gt -1 && $epNum -lt $minEp ]]; then
                        minEp=$epNum;
                fi
        done

        if [[ $minEp -eq 999999 ]]; then
                exit  0;
        fi

        for f in "${files[@]}"; do
                epNum=$(numExtract "$f");
                nuNme=$((epNum - minEp));
                nuNme=$((nuNme + bias));
                newNme=$(rename_file "$f" "$dir" "$nuNme" "$dryRun");
                echo "Old: $f, new: $newNme";
        done

        exit 0;
}

#will need to extract the episode name from the file before renaming.

renameAll(){
        dir=$1;#is expecting the season number to be passed no the directory.
        dryRun=$2;
        sorted=$3;#another boolean val is expected.
        zero=$4;
        files=( * );
        epCount=1;

        if [[ zero == "true" ]]; then
                epCount = 0;
        fi
        #seasonNum=$(numExtract $dir); #is almost working.
        echo "season num  $dir";

        for f in "${files[@]}"; do
                #echo "file: $f";
                #TODO grab num from directory and from file name then rename file.
                newNme="";
                if [[ "$sorted" == "true" ]];then
                        newNme=$(rename_file "$f" "$dir" "$epCount" "$dryRun");
                else
                #need to change for final version maybe another flag for this section.
                        epNum=$(numExtract "$f");
                        newNme=$(rename_file "$f" "$dir" "$epNum" "$dryRun");
                fi

                echo "Old: $f, new: $newNme";
                ((epCount++));
        done
}
