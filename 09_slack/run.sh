#!/bin/bash
set -e
source ../common/menu.sh

menu "Install Slack (instant messaging)?" \
	"Yes, install Slack" './install.sh'
