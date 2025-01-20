#!/bin/bash

source products.sh

title="Install IDEs and configure them?"
alts=""
declare -A all_alts
for code in "${product_codes[@]}"; do
	alt="Install ${product_names[$code]} (${product_desc[$code]})"
	all_alts[$code]="$alt"
	alts="${alts}${alt}\n"
done
esc="Cancel"
alts="${alts}${esc}"

while true; do
	if [ "${alts}" = "${esc}" ]; then
		res="${esc}"
	else
		res=$(printf "${alts}" | fzf --tac --margin=4 --border --border-label="${title}")
	fi

	selected_cancel=1
	for code in "${product_codes[@]}"; do
		if [ "${res}" = "${all_alts[$code]}" ]; then
			selected_cancel=0
			alts=$(echo "${alts}" | sed "s/\\${all_alts[$code]}\\\\n//g")
			./install.sh "$code" "${product_dir[$code]}"
		fi
	done
	if [ "$selected_cancel" -eq 1 ]; then
		exit 0
	fi
done
