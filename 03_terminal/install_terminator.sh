#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

sudo pacman -S --needed terminator
if ! grep -sq "cursor_blink" "$confdir"/terminator/config ; then
    mkdir -p "$confdir"/terminator
    echo "[keybindings]" >> "$confdir"/terminator/config
    echo "  help =" >> "$confdir"/terminator/config
    echo "[profiles]" >> "$confdir"/terminator/config
    echo "  [[default]]" >> "$confdir"/terminator/config
    echo "    cursor_blink = False" >> "$confdir"/terminator/config
    echo "    scrollback_lines = 50000" >> "$confdir"/terminator/config
    echo "    use_system_font = False" >> "$confdir"/terminator/config
    echo "    font = Source Code Pro 16" >> "$confdir"/terminator/config
fi
mkdir -p "$datadir"/icons/hicolor/scalable/apps
cp /usr/share/icons/hicolor/scalable/apps/terminator.svg "$datadir"/icons/hicolor/scalable/apps
