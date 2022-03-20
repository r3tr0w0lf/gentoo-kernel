#!/usr/bin/env bash

# Exit mechanism
trap "exit" INT
set -e

# Author: https://github.com/x0rzavi
# Description: Release to github and temporarily upload built kernel archive to https://temp.sh/
# Dependencies: github-cli

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
    echo $GITHUB_CLI_TOKEN > github_cli_token
    gh auth login --with-token < github_cli_token
    gh release create $release_tag $workdir/linux.7z $workdir/download_link.txt --generate-notes
}

kernel_upload
kernel_release
