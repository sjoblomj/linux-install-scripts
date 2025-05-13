#!/bin/bash
source ../common/install.sh
source ../common/menu.sh

if [ "$(is_ubuntu)" -eq 1 ]; then
	terminal="Terminator"
else
	terminal="Ghostty"
fi


menu "Install terminal and config?" \
    "Install and configure $terminal (terminal)" './install_terminal.sh' \
    "Install yazi (terminal file manager)" './install_yazi.sh' \
    "Configure fzf" './configure_fzf.sh' \
    "Install humanlog (log prettifier)" './install_humanlog.sh' \
    "Install jq and yq (command line processor for JSON, YAML, XML, CSV etc)" './install_yq.sh'
