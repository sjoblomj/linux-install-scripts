#!/bin/bash
source ../common/install.sh

title="Install web browsers? (Select with Tab, Esc to quit)"
chromium="chromium"
if [ $(is_ubuntu) ]; then
	chromium="chromium-browser"
fi

selections=$(printf "firefox\n$chromium\ntorbrowser-launcher" | fzf --multi --tac --margin=4 --border --border-label="${title}")

if [ "$selections" != "" ]; then
	install_programs $selections
	if [[ "$selections" =~ "firefox" ]]; then
		./arkenfox.sh
	fi
	if [[ "$selections" =~ "$chromium" ]]; then
		sudo sed -i "s|^Exec=/usr/bin/chromium|Exec=/usr/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland|g" /usr/share/applications/"$chromium".desktop
	fi
	mkdir -p $HOME/.local/share/icons/hicolor/scalable/apps
	for s in $selections; do
		filename=${s%-*}
		cp "${filename}.svg" "$HOME/.local/share/icons/hicolor/scalable/apps/${filename}.svg"
	done
fi
