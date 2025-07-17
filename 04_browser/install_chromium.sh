#!/bin/bash
set -e
source ../common/install.sh

chromium="chromium"
if [ "$(is_ubuntu)" -eq 1 ]; then
	chromium="chromium-browser"
fi

install_programs "$chromium"
sudo sed -i "s|^Exec=/usr/bin/chromium|Exec=/usr/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland|g" /usr/share/applications/"$chromium".desktop

mkdir -p "$HOME"/.local/share/icons/hicolor/scalable/apps
cp chromium.svg "$HOME/.local/share/icons/hicolor/scalable/apps/chromium.svg"
