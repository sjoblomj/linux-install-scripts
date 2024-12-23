#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

preview_dir="programs/"
title="Choose programs to install (Select with Tab)"
selections=$(ls "$preview_dir" | fzf --multi --layout=reverse --margin=4 --border --border-label="${title}" --preview "cat ${preview_dir}{}" --preview-window right:wrap)

if [ "$selections" != "" ]; then
	sudo pacman -S --needed $selections
	if [[ "$selections" =~ "vlc" ]]; then
		sudo pacman -S --needed qt5-wayland
		mkdir -p "$datadir"/icons/hicolor/scalable/apps
		curl https://upload.wikimedia.org/wikipedia/commons/e/e6/VLC_Icon.svg -o "$datadir"/icons/hicolor/scalable/apps/vlc.svg
	fi
	if [[ "$selections" =~ "lximage-qt" ]]; then
		sudo pacman -S --needed qt6-wayland qt6-imageformats kimageformats
		sudo pacman -S --needed deepin-icon-theme
		mkdir  -p "$confdir"/lximage-qt
		if [ ! -f "$confdir"/lximage-qt/settings.conf ]; then
			echo "[General]" >> "$confdir"/lximage-qt/settings.conf
			echo "fallbackIconTheme=vintage" >> "$confdir"/lximage-qt/settings.conf
		fi
	fi
	if [[ "$selections" =~ "evince" ]]; then
		if [ -f /usr/share/applications/org.gnome.Evince.desktop ] && [ ! -f /usr/share/applications/evince.desktop ]; then
			sudo cp /usr/share/applications/org.gnome.Evince.desktop /usr/share/applications/evince.desktop
		fi
	fi
	if [[ "$selections" =~ "transmission-qt" ]]; then
		sudo pacman -S --needed qt6-wayland
		sudo curl https://upload.wikimedia.org/wikipedia/commons/4/46/Transmission_Icon.svg -o /usr/share/icons/hicolor/scalable/apps/transmission.svg
		sudo curl https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Transmission_Icon.svg/48px-Transmission_Icon.svg.png -o /usr/share/icons/hicolor/48x48/apps/transmission.png
		sudo gtk-update-icon-cache /usr/share/icons/hicolor
	fi
fi
