#! /bin/bash

parentPath=$1
destinationPath=$2


pushd $parentPath
for item in *
do
    if [ -d $parentPath/$item ]
        then
        newPath="$destinationPath/$item"
        mkdir $newPath
        bash ~/code/vsiCropping/replicateDirectoryTree.sh "$parentPath/$item" $newPath
    fi
done
popd