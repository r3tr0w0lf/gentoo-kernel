#!/usr/bin/env bash

# Exit mechanism
trap "exit" INT
set -e

# Author: https://github.com/x0rzavi
# Description: Release to github
# Dependencies: github-cli

workdir=$(pwd)
verbosity () {
    echo -e "\n\n***********************************************"
    echo -e "$1"
    echo -e "***********************************************\n\n"
}

kernel_release () {
    echo $GITHUB_CLI_TOKEN > github_cli_token
    gh auth login --with-token < github_cli_token
    gh release create $release_tag $workdir/linux.7z --generate-notes
}

kernel_release
