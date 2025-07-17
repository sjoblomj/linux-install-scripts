#!/bin/bash
set -e
source ../common/menu.sh

menu "Install zsh (Terminal shell) and config?" \
	"Install zsh and configure oh-my-zsh (zsh config)" './install_oh-my-zsh.sh'
