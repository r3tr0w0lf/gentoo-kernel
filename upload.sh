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
    curl --no-progress-meter -T $workdir/usr/src/linux/linux.7z "https://oshi.at/$release_tag.7z?expire=43200" | sed -n '3p' | sed 's/ \[Download\]//' > /usr/src/linux/download_link.txt
    download_link=$(cat $workdir/usr/src/linux/download_link.txt)
    verbosity $download_link
}

kernel_upload
