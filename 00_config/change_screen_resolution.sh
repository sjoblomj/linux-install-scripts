#!/bin/bash
set -e
prevdir="$(pwd)"
cd "$(dirname "$(readlink -f "$0")")" || exit 1

source ../common/cronjobs.sh
source ../common/menu.sh

change=1
cmd=""
while [ $change -eq 1 ]; do
	alt1="Yes, change screen resolution"
	alt2="No, keep current screen resolution"
	res=$(printf "%s\n%s" "$alt1" "$alt2" | select_menu "Change screen resolution?")
	if [ "${res}" = "${alt1}" ]; then
		if [ ! -d "$HOME"/bin/wlr-randr ]; then
			sudo pacman -S --needed jq
			git clone https://gitlab.freedesktop.org/emersion/wlr-randr.git "$HOME"/bin/wlr-randr
			mkdir -p "$HOME"/bin/letters/update_instructions
			cp build_wlr-randr.sh "$HOME"/bin/letters/update_instructions/wlr-randr
			add_cronjob_to_check_git_repository "$HOME/bin/wlr-randr"
			./build_wlr-randr.sh
		fi
		echo ""
		read -rep "Enter screen scale factor: " factor
		cmd="\$HOME/bin/wlr-randr/build/wlr-randr --output \$(\$HOME/bin/wlr-randr/build/wlr-randr --json | jq '.[].name' --raw-output) --scale $factor"
		eval "$cmd"
	else
		change=0
	fi
done
if [[ -n "$cmd" ]]; then
	{
		echo ""
		echo "# Set scale factor after startup"
		echo "startuptime=\$(date +%s)"
		echo "while [[ \$((startuptime + 5)) -gt \$(date +%s) ]] && [[ -z \$LABWC_PID ]]; do sleep 0.1; done"
		echo "$cmd"
	} >> "$HOME"/.zprofile
fi
cd "$prevdir" || exit 1
