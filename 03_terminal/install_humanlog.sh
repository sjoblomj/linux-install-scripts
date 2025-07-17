#!/bin/bash
set -e
source ../common/install.sh
source ../common/path.sh

install_programs curl

mkdir -p "$HOME"/bin
export HUMANLOG_INSTALL=$HOME/bin/humanlog

# Install
if [ ! -d "$HUMANLOG_INSTALL" ]; then
	curl -L "https://humanlog.io/install.sh" | bash
fi

add_to_path_if_not_present "$HUMANLOG_INSTALL/bin"
