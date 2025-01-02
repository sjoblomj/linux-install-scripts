#!/bin/bash

title="Install terminal and config?"
alt1="Install and configure Ghostty (terminal)"
alt2="Install yazi (terminal file manager)"
alt3="Configure fzf"
alt4="Install humanlog (log prettifier)"
alt5="Install jq and yq (command line processor for JSON, YAML, XML, CSV etc)"
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
		./install_terminal.sh
	elif [ "${res}" = "${alt2}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt2}\\\\n//g")
		./configure_yazi.sh
	elif [ "${res}" = "${alt3}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt3}\\\\n//g")
		./configure_fzf.sh
	elif [ "${res}" = "${alt4}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt4}\\\\n//g")
		./install_humanlog.sh
	elif [ "${res}" = "${alt5}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt5}\\\\n//g")
		./install_yq.sh
	else
		exit 0
	fi
done
