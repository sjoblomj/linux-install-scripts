#!/bin/bash
(
	set -e
	labwc_path="${1:-$(find "$HOME"/bin/labwc -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)}"
	args=("${@:2}") # Additional arguments for meson setup
	if [ ${#args[@]} -eq 0 ] && ! command -v Xwayland > /dev/null; then
		args=(-Dxwayland=disabled)
	fi
	cd "$labwc_path" || exit 1
	meson setup "${args[@]}" build/
	meson compile -C build/
	cd - || exit 1
	sed -i '/XDG_VTNR/s|\(&&.*&&\).*|\1 '"$labwc_path"'/build/labwc \&|' "$HOME/.zprofile"
)
