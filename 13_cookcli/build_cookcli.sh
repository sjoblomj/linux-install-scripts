#!/bin/bash
(
	set -e
	prevdir=$(pwd)
	cd "$HOME"/bin/cookcli || exit 1
	git pull
	npm install
	npm run build-css
	cargo build --release
	cd "$prevdir" || exit 1
)
