#!/bin/bash
source ../common/install.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ "$(is_ubuntu)" -eq 1 ]; then
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
    font = FiraCode Nerd Font Mono 16
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

keybind = alt+up=goto_split:up
keybind = alt+down=goto_split:down
keybind = alt+right=goto_split:right
keybind = alt+left=goto_split:left
keybind = ctrl+shift+up=resize_split:up,10
keybind = ctrl+shift+down=resize_split:down,10
keybind = ctrl+shift+right=resize_split:right,10
keybind = ctrl+shift+left=resize_split:left,10
keybind = ctrl+shift+x=toggle_split_zoom
keybind = ctrl+shift+w=close_surface
keybind = super+t=toggle_tab_overview
" >> "$confdir"/ghostty/config
	fi
fi
