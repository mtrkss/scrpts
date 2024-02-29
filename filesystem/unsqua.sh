#!/bin/sh

destpath="$2"
[ -z "$2" ] && destpath="squashfs-root"

squashpath="$3"
[ -z "$3" ] && squashpath="LiveOS/rootfs.img"

for incompat in Windows Linux Haiku BeOS Solaris Darwin MacOS # this script is only compatible with FreeBSD and its forks.
do [ "$(uname)" = "$incompat" ] && printf "This script is not compatible with ${incompat}\n" && exit 1
done

[ "$(whoami)" != root ] && printf "This script is meant to be ran as root!\n" && exit 1

_helpmsg() {
cat <<EOF>&2
Usage: $0 linux.iso /where/to/extract {Optional SquashFS Path}

Example: $0 /root/artixlinux.iso /compat/artix LiveOS/rootfs.img

This script can be used to easily extract the SquashFS from a Linux ISO.
EOF
exit $1
}

error() {
printf "%s\n" "Error: $1"
exit $2
}

chkapp() {
printf "Searching for $1...\n"
which $1 2>/dev/null && printf "$1 found\n\n" ||
error "$1 not found! Please install the $2 package." 1
}

[ -z "$1" ] && _helpmsg 0

chkapp unsquashfs squashfs-tools

disc=$(mdconfig "$1")
inter=/tmp/$(md5sum<"$0"|head -c10)
echo $inter
[ -d $inter ] || mkdir -pv $inter

mount -t cd9660 /dev/$disc $inter || exit 1
unsquashfs -d "$destpath" "$inter/$squashpath"

umount /dev/$disc
mdconfig -d -u $disc
rm -rv "$inter"
