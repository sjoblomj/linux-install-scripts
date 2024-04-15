#!/bin/bash
filename="$1"
component="$2"
cmd="$3"

NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
F_UNDERLINE="\033[4m"
C_GREY46="\033[38;5;243m"
C_WHITE="\033[38;5;15m"
echo -e "${F_BOLD}${F_UNDERLINED}${C_WHITE}New $component updates available${NO_FORMAT}" > "$filename"
echo -e "${C_WHITE}Run the following command to update:${NO_FORMAT}" >> "$filename"
echo -e "${C_GREY46}$cmd${NO_FORMAT}" >> "$filename"
