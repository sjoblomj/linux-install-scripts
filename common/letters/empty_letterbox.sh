#!/bin/sh
set -e

if [ -n "$(ls -A "$HOME"/.letters)" ] && [ "$XDG_SESSION_TYPE" != "tty" ] ; then
	for file in  "$HOME"/.letters/*; do
		if [ -f "$file" ]; then
			cat "$file"
			rm  "$file"
			echo ""
		fi
	done
fi
