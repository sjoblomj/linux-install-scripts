#!/bin/bash
set -e
source ../common/menu.sh

menu "Setup Mullvad (VPN)?" \
	"Yes, setup Mullvad" './install.sh'
