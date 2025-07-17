#!/bin/bash
set -e
source ../common/menu.sh
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

titleA="Add more locales? (Select with tab)"
titleC="Configure locale for calendar?"
waybarConfigPath="$confdir/waybar/config"

selection=$(grep -Po "^#\K\S*" /etc/locale.gen | multi_select_menu "$titleA")

if [ -n "$selection" ]; then
	for l in $selection; do
		sudo sed -i "s/#$l/$l/" /etc/locale.gen
	done
	sudo locale-gen
fi


if [ -f "$waybarConfigPath" ]; then
	if ! grep -sq "Calendar locale" "$waybarConfigPath" ; then
		selection=$(grep -Po "^[^#]\S*" /etc/locale.gen | select_menu "$titleC")
		if [ -n "$selection" ]; then
			sed -i "s|\"clock\": {$|\"clock\": {\n        \"locale\"  : \"${selection}\", // Calendar locale|" "$waybarConfigPath"
		fi
	fi
fi
