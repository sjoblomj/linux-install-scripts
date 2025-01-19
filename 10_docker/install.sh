#!/bin/bash

source ../common/aliases.sh
source ../common/install.sh

if [ $(is_ubuntu) -eq 1 ]; then
	curl -fsSL https://get.docker.com | sudo sh
	# TODO: Likely not needed:
	#install_programs uidmap dbus-user-session docker-ce-rootless-extras
else
	install_programs docker docker-compose
fi
sudo systemctl start  docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "${USER}"

make_alias "alias dc='docker-compose'"
make_alias "alias clean-docker='if [[ \$(docker ps -qa) ]]; then docker stop \$(docker ps -qa) ; docker rm \$(docker ps -qa) ; fi; if [[ \$(docker volume ls -qf dangling=true) ]]; then docker volume rm \$(docker volume ls -qf dangling=true); fi'"
