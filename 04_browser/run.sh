#!/bin/bash
set -e
source ../common/menu.sh

menu "Install web browsers?" \
	"Install Firefox" './install_firefox.sh' \
	"Install Chromium" './install_chromium.sh' \
	"Install Tor Browser" './install_tor.sh'
