#!/bin/bash
source ../common/install.sh
source ../common/cronjobs.sh

if [ "$(is_ubuntu)" -eq 1 ]; then
	install_programs pipx
else
	install_programs python-pipx
fi

pipx install beancount
pipx install beanquery
pipx install fava

if [ -d "$HOME"/.vim_runtime ] && [ ! -d "$HOME"/.vim_runtime/my_plugins/vim-beancount ]; then
	prevdir=$(pwd)
	git clone https://github.com/nathangrigg/vim-beancount.git "$HOME"/.vim_runtime/my_plugins/vim-beancount

	cd "$HOME"/.vim_runtime/my_plugins/vim-beancount || exit 1
	git remote add patricklucas https://github.com/patricklucas/vim-beancount.git
	git fetch --all
	git checkout 56c072a # Merge support for non-ASCII account names
	cd "$prevdir" || exit

	add_cronjob_to_check_git_repository "$HOME/.vim_runtime/my_plugins/vim-beancount" vim-beancount
fi
