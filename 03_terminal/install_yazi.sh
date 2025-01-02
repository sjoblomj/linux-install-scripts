#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

sudo pacman -S --needed yazi
if ! grep -sq "max_width" "$confdir"/yazi/yazi.toml ; then
	mkdir -p "$confdir"/yazi
	echo "
[preview]
max_width = 4096
max_height = 4096
" >> "$confdir"/yazi/yazi.toml
fi
