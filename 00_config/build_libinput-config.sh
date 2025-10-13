#!/bin/bash
(
	set -e
	prevdir=$(pwd)
	cd "$HOME"/bin/libinput-config || exit 1
	git pull
	meson setup build/
	cd build/ || exit 1
	ninja
	sudo ninja install
	cd "$prevdir" || exit 1
)
