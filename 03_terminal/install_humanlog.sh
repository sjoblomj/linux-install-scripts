#!/bin/bash
mkdir -p $HOME/bin
export HUMANLOG_INSTALL=$HOME/bin/humanlog

# Install
if [ ! -d $HUMANLOG_INSTALL ]; then
	curl -L "https://humanlog.io/install.sh" | sh
fi

# Add to PATH if not present
if grep -sq "^export PATH=.*humanlog.*" $HOME/.zshrc ; then
	: # Do nothing, already on the path
elif grep -sq "^export PATH=" $HOME/.zshrc ; then
	sed -i "s|^export PATH=|export PATH=$HUMANLOG_INSTALL/bin:|" $HOME/.zshrc
else
	echo "export PATH=$HUMANLOG_INSTALL/bin:\$PATH" >> $HOME/.zshrc
fi
