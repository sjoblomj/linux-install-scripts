#!/bin/bash
set -e

if [ ! -d $HOME/code/feeder ]; then
	git clone https://github.com/sjoblomj/feeder.git $HOME/code/feeder
	cp sites.yaml $HOME/code/feeder
	cd $HOME/code/feeder || exit 1
	git update-index --assume-unchanged sites.yaml
	cd - || exit 1
fi
