#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

sudo pacman -S --needed ghostty
if ! grep -sq "cursor-style-blink" "$confdir"/ghostty/config ; then
	mkdir -p "$confdir"/ghostty
	echo "
class = ghostty
font-size = 16
cursor-style-blink = false
shell-integration-features = no-cursor
linux-cgroup = always

keybind = alt+up=goto_split:top
keybind = alt+down=goto_split:bottom
keybind = alt+right=goto_split:right
keybind = alt+left=goto_split:left
keybind = ctrl+shift+x=toggle_split_zoom
" >> "$confdir"/ghostty/config
fi
