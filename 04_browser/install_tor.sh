#!/bin/bash
set -e
source ../common/install.sh

install_programs torbrowser-launcher
mkdir -p "$HOME"/.local/share/icons/hicolor/scalable/apps
cp torbrowser.svg "$HOME/.local/share/icons/hicolor/scalable/apps/torbrowser.svg"
