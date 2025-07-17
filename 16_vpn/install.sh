#!/bin/bash
set -e
source ../common/install.sh

if [ $(is_ubuntu) -eq 1 ]; then
	echo "Automatic setup is not available for Ubuntu"
else
	install_programs openresolv wireguard-tools

	sudo cp se-got-wg-004.conf /etc/wireguard

	sudo systemctl enable wg-quick@se-got-wg-004.service
	sudo systemctl start  wg-quick@se-got-wg-004.service

	# Make WireGuard resume after sleep
	# https://wiki.archlinux.org/title/WireGuard#Connection_lost_after_sleep_using_systemd-networkd
	sudo sed -E -i 's/^#?ManageForeignRoutingPolicyRules=(yes|no)$/ManageForeignRoutingPolicyRules=no/' /etc/systemd/networkd.conf
	sudo systemctl restart systemd-networkd
fi
