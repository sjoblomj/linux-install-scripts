#!/bin/bash
set -e
source ../common/menu.sh

menu "Install feeder (Feed aggregator)?" \
	"Yes, install and configure Feeder" './install.sh'
