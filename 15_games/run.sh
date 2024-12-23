#!/bin/bash

title="Install Games and configure them?"
alt1="Install Zelda and Gamepad config"
alt2="Install WarCraft II (through Wargus and Stratagus)"
alt3="Install Settlers II (Using Return to the Roots)"
alt4="Install The Secret of Monkey Island"
esc="Cancel"
alts="${alt1}\n${alt2}\n${alt3}\n${alt4}\n${esc}"

while true; do
	if [ "${alts}" = "${esc}" ]; then
		res="${esc}"
	else
		res=$(printf "${alts}" | fzf --tac --margin=4 --border --border-label="${title}")
	fi


	if [ "${res}" = "${alt1}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt1}\\\\n//g")
		./zelda.sh
	elif [ "${res}" = "${alt2}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt2}\\\\n//g")
		./warcraft.sh
	elif [ "${res}" = "${alt3}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt3}\\\\n//g")
		./settlers2.sh
	elif [ "${res}" = "${alt4}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt4}\\\\n//g")
		./monkeyisland.sh
	else
		exit 0
	fi
done
