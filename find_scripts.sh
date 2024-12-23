#!/bin/bash

scripts=$(find -name 'run.sh' | sort)
for s in $scripts; do
	dir=$(echo "$s" | sed 's|/run.sh||g')
	cd $dir
	./run.sh
	cd - > /dev/null
done
