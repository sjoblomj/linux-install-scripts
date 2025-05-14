#!/bin/bash
source ../common/install.sh
source ../common/menu.sh

preview_dir="programs/"
title="Install Java and tools (Select with Tab)?"
if [ $(is_ubuntu) -eq 1 ]; then
	openjdkpackages="openjdk-[0-9]*-jdk"
else
	openjdkpackages="jdk[0-9]*-openjdk"
fi
javas=$(search_package java | grep -Po "$openjdkpackages" | uniq)
extras="bazel    (Java build automation tool)\nmaven    (Java build automation tool)\nmvntree  (mvn dependency tree prettifier)"

selection=$(printf "$javas\n$extras" | multi_select_menu "$title" | awk '{print $1;}')

if [ "$selection" != "" ]; then
	./install.sh "$selection"
fi
