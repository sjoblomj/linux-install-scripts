#!/bin/bash
source ../common/cronjobs.sh

add_cronjob_to_check_git_repository "$HOME/bin/fzf"

if [ -f $HOME/.fzf.bash ] && [ ! -f $HOME/.fzf.zsh ]; then
    cp $HOME/.fzf.bash $HOME/.fzf.zsh
    sed -i 's/.bash"$/.zsh"/g' $HOME/.fzf.zsh
fi
if ! grep -sq ".fzf.zsh" $HOME/.zshrc ; then
    echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> $HOME/.zshrc
fi
