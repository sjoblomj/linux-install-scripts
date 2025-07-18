#!/bin/bash
set -e

echo "Downloading icons for labwc menu..."

target="$HOME"/.local/share/icons/hicolor/scalable/actions
mkdir -p "$target"
curl https://raw.githubusercontent.com/labwc/labwc/master/data/labwc.svg -o "$target/labwc.svg"
curl https://upload.wikimedia.org/wikipedia/commons/4/4d/Noto_Emoji_Pie_1f680.svg -o "$target/rocket.svg"
curl https://upload.wikimedia.org/wikipedia/commons/e/e2/KGpg_icon.svg -o "$target/lock.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/Sea/apps/scalable/gnome-clocks.svg -o "$target/clock.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/bloom-classic/apps/128/deepin-screenshot.svg -o "$target/screenshot.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/bloom/status/48/shutdown-symbolic-reminder.svg -o "$target/shutdown.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/vintage/status/20/refresh.svg -o "$target/reboot.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/vintage/apps/128/deepin-terminal.svg -o "$target/terminal.svg"
curl https://raw.githubusercontent.com/linuxdeepin/deepin-icon-theme/master/vintage/apps/128/deepin-camera.svg -o "$target/camera.svg"
