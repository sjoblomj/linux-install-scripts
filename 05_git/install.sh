#!/bin/bash

source ../common/aliases.sh
source ../common/install.sh

if [ "$(is_ubuntu)" -eq 1 ]; then
	sudo add-apt-repository ppa:aos1/diff-so-fancy
	sudo apt update
	install_programs openssh-client
else
	install_programs openssh
fi
install_programs git diff-so-fancy

echo ""
read -rep "Enter name  (to use globally for git): " name
read -rep "Enter email (to use globally for git): " email

ssh-keygen -t ed25519 -C "$email" -f "$HOME"/.ssh/id_ed25519 -N ""

git config --global user.name  "$name"
git config --global user.email "$email"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global init.defaultBranch main
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cp cherry-pick
git config --global alias.l  "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(red)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
git config --global alias.l2 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(red)- %an%C(reset)'"

make_alias "alias gits='git status'"
