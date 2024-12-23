#!/bin/bash
title="Install web browsers? (Select with Tab, Esc to quit)"
selections=$(printf "firefox\nchromium\ntorbrowser-launcher" | fzf --multi --tac --margin=4 --border --border-label="${title}")

if [ "$selections" != "" ]; then
	sudo pacman -S --needed $selections
	if [[ "$selections" =~ "firefox" ]]; then
		./arkenfox.sh
	fi
	if [[ "$selections" =~ "chromium" ]]; then
		sudo sed -i "s|^Exec=/usr/bin/chromium|Exec=/usr/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland|g" /usr/share/applications/chromium.desktop
	fi
	mkdir -p $HOME/.local/share/icons/hicolor/scalable/apps
	for s in $selections; do
		filename=${s%-*}
		cp "${filename}.svg" "$HOME/.local/share/icons/hicolor/scalable/apps/${filename}.svg"
	done
fi
