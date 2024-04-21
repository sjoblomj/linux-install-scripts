#!/bin/bash
source ../common/cronjobs.sh

sudo pacman -S --needed git vim
git clone --depth=1 https://github.com/amix/vimrc.git $HOME/.vim_runtime
cp my_configs.vim $HOME/.vim_runtime
sh $HOME/.vim_runtime/install_awesome_vimrc.sh
sudo ln -sf $(which vim) /usr/local/bin/vi

add_cronjob_to_check_git_repository "$HOME/.vim_runtime" vimrc
