#!/bin/sh

set -x
set -e

image="$1" ; shift
device="$1" ; shift

bmap=$(dirname "$image")/$(basename "$image" .img).bmap
bmaptool copy --bmap $bmap "$image" $device
partition_start=`parted $device unit s print | awk '$1 == 2 {print $2}'`
parted --script $device rm 2 mkpart p ext4 $partition_start 100%
e2fsck -f ${device}2
resize2fs ${device}2

eject $device
