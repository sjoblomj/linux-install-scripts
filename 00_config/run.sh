#!/bin/bash
source ../common/install.sh
source ../common/menu.sh

if [ "$(is_ubuntu)" -eq 1 ]; then
	label="Setup Ubuntu configuration"
	cmd='./setup_ubuntu.sh'
else
	label="Install labwc and setup system"
	cmd='./install_labwc_system.sh'
fi


menu "Setup system" \
	"$label" "$cmd"
