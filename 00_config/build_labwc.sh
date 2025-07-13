#!/bin/bash
args="$1" # Additional arguments for meson setup
labwc_path="${2:-find "$HOME"/bin/labwc -maxdepth 1 -type d | sort -V | tail -n 1}"
cd "$labwc_path" || exit 1
meson setup "$args" build/
meson compile -C build/
cd - || exit 1
sed -i '/XDG_VTNR/s|\(&&\).*|\1 '"$labwc_path"'/build/labwc \&|' "$HOME/.zprofile"
