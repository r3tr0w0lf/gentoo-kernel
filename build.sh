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
    time make -j$(nproc) olddefconfig &>/dev/null
    for patch in $workdir/patches/*
    do
        patch < $patch
    done
    #wget -O .config --quiet https://raw.githubusercontent.com/x0rzavi/gentoo-bits/main/config-5.16.14-gentoo-x0rzavi
	grep "CONFIG_LOCALVERSION=" -F .config
    echo ""
    verbosity "KERNEL PREPARATION COMPLETED SUCCESSFULLY"
}

kernel_tag () {
    version=$(grep 'Linux/x86' /usr/src/linux/.config | sed 's/# Linux\/x86 /linux-/;s/ Kernel Configuration/-xanmod/')
    seconds=$(stat -c '%X' /usr/src/linux/.config)
    tag="$version-$seconds"
    echo $tag > $workdir/release_tag
    verbosity "KERNEL BUILD RELEASE TAG: $tag"
}

kernel_build () {
    time make -j$(nproc) &>/dev/null
    verbosity "KERNEL BUILD COMPLETED SUCCESSFULLY"
}

kernel_package () {
    time 7z a -t7z $workdir/linux.7z /usr/src/linux-* &>/dev/null
    verbosity "KERNEL PACKAGING COMPLETED SUCCESSFULLY"
}

kernel_prepare
kernel_tag
kernel_build
kernel_package
