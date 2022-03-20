#!/usr/bin/env bash

# Exit mechanism
trap "exit" INT
set -e

# Author: https://github.com/x0rzavi
# Description: Build xanmod kernel on gentoo
# Dependencies: 7z, lz4

workdir=$(pwd)
verbosity () {
    echo -e "\n\n***********************************************"
    echo -e "$1"
    echo -e "***********************************************\n\n"
}

kernel_prepare () {
    cd /usr/src/linux
    cp CONFIGS/xanmod/gcc/config .config
    for patch in $workdir/patches/*
    do
        patch < $patch &>/dev/null
    done
    #wget -O .config --quiet https://raw.githubusercontent.com/x0rzavi/gentoo-bits/main/config-5.16.14-gentoo-x0rzavi
    time make -j$(nproc) olddefconfig &>/dev/null
    echo ""
    grep "CONFIG_LOCALVERSION=" -F .config
    verbosity "KERNEL PREPARATION COMPLETED SUCCESSFULLY"
}

kernel_build () {
    time make -j$(nproc) &>/dev/null
    verbosity "KERNEL BUILD COMPLETED SUCCESSFULLY"
}

kernel_package () {
    time 7z a -t7z $workdir/linux.7z /usr/src/linux-* &>/dev/null
    verbosity "KERNEL PACKAGING COMPLETED SUCCESSFULLY"
}

kernel_tag () {
    version=$(grep 'Linux/x86' /usr/src/linux/.config | sed 's/# Linux\/x86 /linux-/;s/ Kernel Configuration/-xanmod/')
    seconds=$(stat -c '%X' /usr/src/linux/.config)
    tag="$version-$seconds"
    echo $tag > $workdir/release_tag
    verbosity "KERNEL BUILD RELEASE TAG WAS SET SUCCESSFULLY"
}

kernel_prepare
kernel_build
kernel_package
kernel_tag
