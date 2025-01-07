#!/bin/bash
source ../common/install.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ $(is_ubuntu) ]; then
	install_programs terminator

	if ! grep -sq "cursor_blink" "$confdir"/terminator/config ; then
		mkdir -p "$confdir"/terminator
		echo "
[keybindings]
  help =
[profiles]
  [[default]]
    cursor_blink = False
    scrollback_lines = 50000
    use_system_font = False
    font = Source Code Pro 16
" >> "$confdir"/terminator/config
fi
else
	install_programs ghostty
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
fi
