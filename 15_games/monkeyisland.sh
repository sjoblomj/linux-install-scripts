#!/bin/bash

if [ ! -d $HOME/games/the_secret_of_monkey_island ]; then
	mkdir -p $HOME/games/the_secret_of_monkey_island

	sudo pacman -S --needed unzip
	sudo pacman -S --needed scummvm
	curl -L https://archive.org/download/monkey_dos/MONKEY.zip -o /tmp/mi.zip
	unzip /tmp/mi.zip -d $HOME/games/the_secret_of_monkey_island
	rm /tmp/mi.zip
fi
