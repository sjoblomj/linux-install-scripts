#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

titleA="Add more locales? (Select with tab)"
titleC="Configure locale for calendar?"
waybarConfigPath="$confdir/waybar/config"

selection=$(cat /etc/locale.gen | grep -Po "^#\K\S*" | fzf --multi --layout=reverse --margin=4 --border --border-label="$titleA")

if [ "$selection" != "" ]; then
	for l in $selection; do
		sudo sed -i "s/#$l/$l/" /etc/locale.gen
	done
	sudo locale-gen
fi


if [ -f "$waybarConfigPath" ]; then
	if ! grep -sq "Calendar locale" "$waybarConfigPath" ; then
		selection=$(cat /etc/locale.gen | grep -Po "^[^#]\S*" | fzf --tac --margin=4 --border --border-label="$titleC")
		if [ "$selection" != "" ]; then
			sed -i "s|\"clock\": {$|\"clock\": {\n        \"locale\"  : \"${selection}\", // Calendar locale|" "$waybarConfigPath"
		fi
	fi
fi
