#!/bin/bash
(
	set -e
	prevdir=$(pwd)
	cd "$HOME"/bin/wlopm || exit 1
	git pull
	make
	sudo make install
	cd "$prevdir" || exit 1
)
