source ./renameUtils.sh;

#plan
#get season num from path
#change directory
#change all files in directory.
VERSION="1.0.0";
param=$1;

if [[ "$1" == "--version" || "$1" == "-v" ]]; then
        echo "Frename version $VERSION";
        exit 0;
fi

path="tvshows/sopranos/season 1";
p1=$(numExtract "$param");
cd "$param";
pwd
echo "working";

renameAll $p1;
