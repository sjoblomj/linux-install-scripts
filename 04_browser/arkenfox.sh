#!/bin/bash
source ../common/cronjobs.sh
source ../common/install.sh

post_addon_letter() {
	local filename="$HOME/.letters/firefox"
	local currdir=$(pwd)
	mkdir -p $HOME/.letters

	NO_FORMAT="\033[0m"
	F_BOLD="\033[1m"
	F_UNDERLINE="\033[4m"
	C_GREY46="\033[38;5;243m"
	C_WHITE="\033[38;5;15m"
	echo -e "${F_BOLD}${F_UNDERLINED}${C_WHITE}Firefox addons available${NO_FORMAT}" > "$filename"
	echo -e "${C_WHITE}Run the following command to open recommended addons:${NO_FORMAT}" >> "$filename"
	echo -e "${C_GREY46}firefox $currdir/addons.html${NO_FORMAT}" >> "$filename"
}

install_programs git

install_dir="$HOME/bin/arkenfox"
git clone https://github.com/arkenfox/user.js.git $install_dir
cp user-overrides.js $install_dir/user-overrides.js

add_cronjob_to_check_git_repository "$install_dir"
post_addon_letter
