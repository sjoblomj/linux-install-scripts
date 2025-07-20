#!/bin/bash
set -e
source ../common/cronjobs.sh
source ../common/menu.sh

alt1="Yes, change mouse speed"
alt2="No, keep current mouse speed"
res=$(printf "%s\n%s" "$alt1" "$alt2" | select_menu "Change mouse speed?" '
Note that this will change the mouse speed for *all devices*.
For this setting to take effect, a re-login must be performed.')
if [ "${res}" = "${alt1}" ]; then
	if [ ! -d "$HOME"/bin/libinput-config ]; then
		scriptdir=$(readlink -f "$0")
		git clone https://gitlab.com/warningnonpotablewater/libinput-config.git "$HOME"/bin/libinput-config
		mkdir -p "$HOME"/bin/letters/update_instructions
		cp "$scriptdir"/build_libinput-config.sh "$HOME"/bin/letters/update_instructions/libinput-config
		add_cronjob_to_check_git_repository "$HOME"/bin/libinput-config
		"$scriptdir"/build_libinput-config.sh
	fi
	echo ""
	read -rep "Enter mouse speed factor: " factor
	echo "speed=$factor" | sudo tee /etc/libinput.conf
fi
