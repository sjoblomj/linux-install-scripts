#!/bin/bash
set -e
source ../common/menu.sh

menu "Install git and utils?" \
	"Yes, install git, diff-so-fancy, create aliases and set name and email for user" './install.sh'
