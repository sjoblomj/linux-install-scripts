#!/bin/bash
source ../common/install.sh

if [ $(is_ubuntu) -eq 1 ]; then
	alt1="Setup Ubuntu configuration"
else
	alt1="Install labwc and setup system"
fi
title="Setup system"
esc="Cancel"
alts="${alt1}\n${esc}"

while true; do
	if [ "${alts}" = "${esc}" ]; then
		res="${esc}"
	else
		res=$(printf "${alts}" | fzf --tac --margin=4 --border --border-label="${title}")
	fi


	if [ "${res}" = "${alt1}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt1}\\\\n//g")
		if [ $(is_ubuntu) -eq 1 ]; then
			./setup_ubuntu.sh
		else
			./install_labwc_system.sh
		fi
	else
		exit 0
	fi
done
