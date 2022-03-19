#!/usr/bin/env bash

# Exit mechanism
trap "exit" INT
set -e

# Author: https://github.com/x0rzavi
# Description: Temporarily upload built kernel archive to https://oshi.at/

workdir=$(pwd)
verbosity () {
    echo -e "\n\n***********************************************"
    echo -e "$1"
    echo -e "***********************************************\n\n"
}

kernel_upload () {
    release_tag=$(cat $workdir/release_tag)
    curl --no-progress-meter -T $workdir/linux.7z temp.sh > $workdir/download_link.txt
    download_link=$(cat $workdir/download_link.txt)
    verbosity $download_link
}

kernel_release () {
    gh auth login --with-token $GITHUB_TOKEN
    gh release create $release_tag $workdir/linux.7z $workdir/download_link.txt --generate-notes
}

kernel_upload
