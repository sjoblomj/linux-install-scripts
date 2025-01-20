#!/bin/bash

title="Install PDF tools and typesetting systems?"
alt1="Install TeX Live (LaTeX etc)"
alt2="Install mupdf-tools"
esc="Cancel"
alts="${alt1}\n${alt2}\n${esc}"

while true; do
	if [ "${alts}" = "${esc}" ]; then
		res="${esc}"
	else
		res=$(printf "${alts}" | fzf --tac --margin=4 --border --border-label="${title}")
	fi


	if [ "${res}" = "${alt1}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt1}\\\\n//g")
		./install.sh texlive-core texlive-latexextra texlive-langeuropean texlive-binextra texlive-formatsextra texlive-mathscience texlive-xetex
	elif [ "${res}" = "${alt2}" ]; then
		alts=$(echo "${alts}" | sed "s/\\${alt2}\\\\n//g")
		./install.sh mupdf-tools
	else
		exit 0
	fi
done
