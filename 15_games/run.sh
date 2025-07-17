#!/bin/bash
set -e
source ../common/menu.sh

menu "Install and configure games?" \
	"Install Zelda and Gamepad config" './zelda.sh' \
	"Install WarCraft II (through Wargus and Stratagus)" './warcraft.sh' \
	"Install Settlers II (Using Return to the Roots)" './settlers2.sh' \
	"Install The Secret of Monkey Island" './monkeyisland.sh'
