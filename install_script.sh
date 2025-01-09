#!/bin/bash
source common/install.sh

if [ $(is_ubuntu) ]; then
	sudo apt-get update
	sudo apt-get upgrade
else
	sudo pacman-key --init
	sudo pacman-key --populate archlinux
	sudo pacman -Suy
fi
install_programs curl git

if [ -d ".git/hooks" ]; then
	cp commit-msg .git/hooks
	chmod +x .git/hooks/commit-msg
fi

git clone https://github.com/junegunn/fzf.git "$HOME"/bin/fzf
cd "$HOME"/bin/fzf
./install
PATH="${PATH:+${PATH}:}"$HOME"/bin/fzf/bin"

git clone https://github.com/sjoblomj/linux-install-scripts "$HOME"/code/linux-install-scripts
cd "$HOME"/code/linux-install-scripts

./find_scripts.sh
