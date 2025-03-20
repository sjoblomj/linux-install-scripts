#!/bin/bash

is_ubuntu() {
	if [ "$(awk -F= '/^NAME/{gsub("\"", "", $2); print $2}' /etc/os-release)" = "Ubuntu" ]; then
		echo 1
	else
		echo 0
	fi
}

install_programs() {
	if [ "$(is_ubuntu)" -eq 1 ]; then
		sudo apt-get install "$@"
	else
		sudo pacman -S --needed "$@"
	fi
}

search_package() {
	if [ "$(is_ubuntu)" -eq 1 ]; then
		apt-cache search "$@"
	else
		pacman -Ss "$@"
	fi
}
