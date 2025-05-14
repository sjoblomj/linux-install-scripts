#!/bin/bash

# Creates a menu with the given title. Accepts argument pairs of labels and commands.
# When the user choses a label, the corresponding command is executed.
# A cancel option is always available and is automatically added.
# Each time a user choses an option, that option is removed from the menu. When there
# are no more options left (apart from the cancel option), the menu is closed.
# The user can close the menu at any time by pressing Ctrl-C or Esc.
function menu() {
	local title="$1"
	shift
	local args=("$@")
	_menu "$title" "" "${args[@]}"
}

# Same as the menu function, but with an explanation text.
function menu_with_explanation() {
	local title="$1"
	local explanation="$2"
	shift 2
	local args=("$@")
	_menu "$title" "$explanation" "${args[@]}"
}

# Creates a menu with the given title. Optionally an explanation text can be given.
# The menu items are read from stdin. The user can select one item, and the selection
# is returned to the caller.
function select_menu() {
	local title="$1"
	local explanation="$2"
	cat </dev/stdin | fzf --tac --margin=4 --border --border-label="$title" --header="$explanation"
}

# Creates a menu with the given title. Optionally a preview command can be given,
# which will give the menu a preview window on the right side.
# The menu items are read from stdin. The user can select one or more items, and
# the selected items are returned to the caller.
function multi_select_menu() {
	local title="$1"
	local preview="$2"
	if [ -n "$preview" ]; then
		cat </dev/stdin | fzf --multi --layout=reverse --margin=4 --border --border-label="$title" --preview "$preview" --preview-window right:wrap
	else
		cat </dev/stdin | fzf --multi --layout=reverse --margin=4 --border --border-label="$title"
	fi
}

function _menu() {
	local title="$1"
	local explanation="$2"
	shift 2

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
		selection=$(printf "%s\n" "${labels[@]}" | fzf --tac --margin=4 --border --border-label="${title}" --header="$explanation")

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

