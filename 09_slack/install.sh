#!/bin/bash
set -e
prevdir=$(pwd)

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/slack-desktop.git $HOME/bin/slack-desktop

cd $HOME/bin/slack-desktop || exit 1
makepkg -sir
cd "$prevdir" || exit 1
