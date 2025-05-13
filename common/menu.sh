#!/bin/bash

function menu() {
	local title="$1"
	shift

	local cancel_lbl="Cancel"
	local cancel_cmd="exit 0"
	local labels=()
	local commands=()

	# Collect alternating label-command pairs
	while [[ $# -gt 1 ]]; do
		labels+=("$1")
		commands+=("$2")
		shift 2
	done
	labels+=("$cancel_lbl")
	commands+=("$cancel_cmd")

	while [[ ${#labels[@]} -gt 0 ]]; do
		# Show fzf menu with remaining labels
		selection=$(printf "%s\n" "${labels[@]}" | fzf --tac --margin=4 --border --border-label="${title}")

		# Find the index of the selected label
		for i in "${!labels[@]}"; do
			if [[ "${labels[$i]}" == "$selection" ]]; then
				# Run the associated command
				eval "${commands[$i]}"

				# Remove the selected item
				unset 'labels[i]'
				unset 'commands[i]'

				# Compact arrays to remove gaps
				labels=("${labels[@]}")
				commands=("${commands[@]}")
				break
			fi
		done

		# Exit if user cancels or there are no more items left
		if [[ -z "$selection" ]] || [[ "$selection" == "$cancel_lbl" ]] || [[ ${#labels[@]} -eq 1 && ${labels[0]} == "$cancel_lbl" ]] ; then
			break
		fi
	done
}
