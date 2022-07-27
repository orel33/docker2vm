#!/bin/bash

[ ! $# -eq 2 ] && echo "Usage: $0 <docker> <vm.img>" && exit 1

DOCKERIMG="$1"
VMIMG="$2"

set -e # immediately exit on first error

echo_blue() {
    local font_blue="\033[94m"
    local font_bold="\033[1m"
    local font_end="\033[0m"
    echo -e "\n${font_blue}${font_bold}${1}${font_end}"
}

echo_blue "[Export docker as a tarball]"
DOCKERCID=$(docker run -d $DOCKERIMG /bin/true)
(set -x ; docker export -o $VMIMG.tar ${DOCKERCID})

echo_blue "[Make a disk image from the tarball]"
(set -x ; virt-make-fs --type=ext3 --partition=mbr --format=raw --size=+2G $VMIMG.tar $VMIMG)

echo_blue "[Remove the temporary tarball]"
(set -x ; rm -f $VMIMG.tar)

echo_blue "[Switch on the boot flag]"
(set -x ; sfdisk --activate $VMIMG 1)

echo_blue "[Write MBR]"
(set -x ; dd if=/usr/lib/syslinux/mbr/mbr.bin of=$VMIMG bs=440 count=1 conv=notrunc)

echo_blue "[List partitions]"
(set -x ; sfdisk -l $VMIMG)

echo_blue "[Install extlinux bootloader]"
(set -x ; guestfish --rw -a $VMIMG -i extlinux /boot)
(set -x ; virt-copy-in -a $VMIMG syslinux.cfg /boot/)

echo_blue "Done!"
