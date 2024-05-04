#!/bin/bash

if [ ! -d $HOME/code/feeder ]; then
    git clone https://github.com/sjoblomj/feeder.git $HOME/code/feeder
    cp sites.yaml $HOME/code/feeder
fi
