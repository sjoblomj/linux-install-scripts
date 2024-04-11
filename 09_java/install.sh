#!/bin/bash

source ../common/aliases.sh
programs="$@"

if [[ "$programs" =~ "mvntree" ]]; then
    prevdir=$(pwd)
    mkdir -p $HOME/code
    cd $HOME/code
    if [ ! -d mvntree ]; then
        git clone https://github.com/sjoblomj/mvntree.git
        echo 'source $HOME/code/mvntree/.mvntree' >> $HOME/.zshrc
    fi
    cd "$prevdir"
    programs=$(echo "${programs}" | sed "s/mvntree//g")
fi

if [[ "$programs" =~ "maven" ]]; then
    make_alias "alias mci='mvn clean install'"
fi

sudo pacman -S --needed ${programs}
