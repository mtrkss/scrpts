#!/bin/sh

# Haiiiii >w<
# This script converts Xresources to FreeBSD VT color schemes
# If you want to convert your existing color scheme to Xresources first, use https://terminal.sexy

[ -z "$1" ] && cat <<EOF>&2&&exit 0
Usage: $0 xresources_file -alt

Example: $0 ~/.Xresources

This script can be used to convert Xresources to FreeBSD tty colorschemes.
Use -alt for alternative foreground and background colors.
EOF

_forloop() {
	for i in $(seq $2 $3)
	do printf "${1}${i} "
	done
}

_dot() {
	if echo $1 | grep -q 'color[0-9]'
	then printf "$1" | sed 's/color\([0-9]\)/color.\1/g'
	elif [ $1 = background ]
	then printf "color.0"
	elif [ $1 = foreground ]
	then printf "color.7"
	fi
}

[ "$2" = "-alt" ] &&
resources="color0 color8 color1 color9 color2 color10 color3 color11 color4 color12 color5 color13 color6 color14 color7 color15" ||
resources="background color8 color1 color9 color2 color10 color3 color11 color4 color12 color5 color13 color6 color14 foreground color15"


for resource in $resources
do
	curcol=$(awk "/\*\.$resource:/ {printf \$2}" "$1")
	echo kern.vt.$(_dot $resource).rgb=\"$curcol\"
done
