#!/bin/bash

is_ubuntu() {
	if [ "$(awk -F= '/^NAME/{gsub("\"", "", $2); print $2}' /etc/os-release)" = "Ubuntu" ]; then
		echo 1
	else
		echo 0
	fi
}

if [ $(is_ubuntu) -eq 1 ]; then
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install curl git
else
	sudo pacman-key --init
	sudo pacman-key --populate archlinux
	sudo pacman -Suy
	sudo pacman -S --needed curl git
fi

git clone https://github.com/junegunn/fzf.git "$HOME"/bin/fzf
cd "$HOME"/bin/fzf
./install
PATH="${PATH:+${PATH}:}"$HOME"/bin/fzf/bin"

git clone https://github.com/sjoblomj/linux-install-scripts "$HOME"/code/linux-install-scripts
cd "$HOME"/code/linux-install-scripts

if [ -d ".git/hooks" ]; then
	cp commit-msg .git/hooks
	chmod +x .git/hooks/commit-msg
fi


./find_scripts.sh
