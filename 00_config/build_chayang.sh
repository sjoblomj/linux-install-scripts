#!/bin/bash
set -e
prevdir=$(pwd)
cd "$HOME"/bin/chayang || exit 1
git pull
meson setup build/
ninja -C build/
sudo cp build/chayang /usr/local/bin/
cd "$prevdir" || exit 1
