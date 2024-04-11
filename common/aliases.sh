#!/bin/bash

make_alias() {
    alias="$1"
    if ! grep -sq "$alias" $HOME/.zshaliases; then
        echo "$alias" >> $HOME/.zshaliases
    fi
    if ! grep -sq "source \$HOME/.zshaliases" $HOME/.zshrc ; then
        echo "souce \$HOME/.zshaliases" >> $HOME/.zshrc
    fi
}
