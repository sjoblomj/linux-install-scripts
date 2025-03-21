#!/bin/bash
filename="$1"
component="$2"
cmd="$3"
if [ -z "$cmd" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	if [ -f "$SCRIPT_DIR"/update_instructions/"$component" ]; then
		cmd=$(cat "$SCRIPT_DIR"/update_instructions/"$component")
	else
		cmd="No command provided"
	fi
fi

NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
F_UNDERLINE="\033[4m"
C_GREY46="\033[38;5;243m"
C_WHITE="\033[38;5;15m"
echo -e "${F_BOLD}${F_UNDERLINE}${C_WHITE}New $component updates available${NO_FORMAT}" > "$filename"
echo -e "${C_WHITE}Run the following command to update:${NO_FORMAT}" >> "$filename"
echo -e "${C_GREY46}$cmd${NO_FORMAT}" >> "$filename"
