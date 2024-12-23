#!/bin/bash
preview_dir="programs/"
title="Install Java and tools (Select with Tab)?"
javas=$(pacman -Ss java | grep -Po "jdk[0-9]*-openjdk" | uniq)
extras="bazel    (Java build automation tool)\nmaven    (Java build automation tool)\nmvntree  (mvn dependency tree prettifier)"

selection=$(printf "$javas\n$extras" | fzf --multi --tac --margin=4 --border --border-label="${title}" | awk '{print $1;}')

if [ "$selection" != "" ]; then
	./install.sh "$selection"
fi
