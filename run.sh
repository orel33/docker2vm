#!/bin/bash

[ ! $# -eq 1 ] && echo "Usage: $0 <vm.img>" && exit 1
VMIMG="$1"
[ ! -f "$VMIMG" ] && echo "Error: input image file is missing!" && exit 1

# qemu-img create -q -b debian11.img -F raw -f qcow2 debian11.qcow2

BASICOPT="-enable-kvm -rtc base=localtime -k fr -m 2048 -cpu host"
NETOPT="-netdev user,id=mynet0 -device e1000,netdev=mynet0"
DRIVEOPT="-drive file=$VMIMG,index=0,media=disk,format=raw"
ALLOPT="$BASICOPT $NETOPT $DRIVEOPT -nographic"
CMD="qemu-system-x86_64 $ALLOPT"
( set -x ; bash -c "$CMD" )

# EOF
