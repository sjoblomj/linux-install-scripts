#!/bin/bash
set -e

function add_to_path_if_not_present() {
	path_to_add="$1"
	rcfile=".${2:-zsh}rc"

	# Add to PATH if not present
	if grep -sq "^export PATH=.*$path_to_add.*" "$HOME/$rcfile" ; then
		: # Do nothing, already on the path
	elif grep -sq "^export PATH=" "$HOME/$rcfile" ; then
		sed -i "s|^export PATH=|export PATH=$path_to_add:|" "$HOME/$rcfile"
	else
		echo "export PATH=$path_to_add:\$PATH" >> "$HOME/$rcfile"
	fi
	export PATH="$path_to_add:$PATH"
}
