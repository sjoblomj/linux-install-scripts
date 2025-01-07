#!/bin/bash
source ../common/cronjobs.sh

prevdir=$(pwd)
if [ ! -d $HOME/bin/fzf ]; then
	git clone https://github.com/junegunn/fzf.git $HOME/bin/fzf
	cd $HOME/bin/fzf
	./install
fi
cd "$prevdir" || exit 1

add_cronjob_to_check_git_repository "$HOME/bin/fzf"

if [ -f $HOME/.fzf.bash ] && [ ! -f $HOME/.fzf.zsh ]; then
	cp $HOME/.fzf.bash $HOME/.fzf.zsh
	sed -i 's/bash/zsh/g' $HOME/.fzf.zsh
fi
if ! grep -sq ".fzf.zsh" $HOME/.zshrc ; then
	echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> $HOME/.zshrc
fi
