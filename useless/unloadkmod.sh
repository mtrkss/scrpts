#!/bin/sh
# fun fact: this script does not contain any "echo" or "if" commands.

eeptime=2
dumb_arg="--i-have-a-peanut-instead-of-a-brain"

[ $(uname) != "FreeBSD" ] && [ "$1" != "$dumb_arg"] &&
printf "This script is only meant for FreeBSD.\nIf you still want to run it, pass $dumb_arg as an argument to this script.\n" && exit

WARN(){
	printf 'WARNING! THIS SCRIPT WILL TRY TO UNLOAD ALL YOUR KERNEL MODULES ONE BY ONE!\n'
	printf '\nTo continue, type "Yes, do as I say!" and press enter.\nAnswer: '
	read ans
	[ "$ans" != "Yes, do as I say!" ] && exit
	printf "Executing...\n"
}

[ $(whoami) != root ] && printf "Run this script as root...\nIf you're brave enough :3\n" && exit
WARN

# the actual script only starts here lmao
kmods="$(kldstat|awk '{printf $5" "}'|tail -c+6)"
for kmod in $kmods
do printf "\nUnloading $kmod... "
   sleep $eeptime
   kldunload -v -f $kmod
done
