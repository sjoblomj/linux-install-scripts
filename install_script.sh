#!/bin/bash

sudo pacman-key --init
sudo pacman-key --populate archlinux

sudo pacman -Suy
sudo pacman -S --needed git

if [ -d ".git/hooks" ]; then
  cp commit-msg .git/hooks
  chmod +x .git/hooks/commit-msg
fi

git clone https://github.com/junegunn/fzf.git $HOME/bin/fzf
cd $HOME/bin/fzf
./install
PATH="${PATH:+${PATH}:}$HOME/bin/fzf/bin"

git clone https://github.com/sjoblomj/arch-install-scripts $HOME/code/arch-install-scripts
cd $HOME/code/arch-install-scripts

./find_scripts.sh
