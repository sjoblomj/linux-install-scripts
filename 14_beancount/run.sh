#!/bin/bash
set -e
source ../common/menu.sh

menu "Install beancount (Plain text accounting tool)?" \
	"Yes, install beancount" './install.sh'
