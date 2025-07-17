#!/bin/bash
set -e
prevdir=$(pwd)
cd "$HOME"/bin/wlr-randr || exit 1
git pull
meson setup build/
ninja -C build/
cd "$prevdir" || exit 1
