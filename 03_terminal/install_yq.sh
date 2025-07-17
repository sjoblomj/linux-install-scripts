#!/bin/bash
set -e
source ../common/install.sh
source ../common/path.sh

install_programs jq
if [ "$(is_ubuntu)" -eq 1 ]; then
	install_programs golang-go
else
	install_programs go
fi

# Install
if [ ! -f "$HOME"/go/bin/yq ]; then
	go install github.com/mikefarah/yq/v4@latest
fi

add_to_path_if_not_present "$HOME/go/bin"
