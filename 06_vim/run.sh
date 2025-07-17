#!/bin/bash
set -e
source ../common/menu.sh

menu "Install and configure vimrc (tweaked vim)?" \
	"Yes, install vimrc" './install.sh'
