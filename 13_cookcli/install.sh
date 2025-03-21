#!/bin/bash
source ../common/cronjobs.sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env" # source cargo

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 22

if [ ! -d "$HOME"/bin/cookcli ]; then
	git clone https://github.com/cooklang/cookcli.git "$HOME"/bin/cookcli
	mkdir -p "$HOME"/bin/letters/update_instructions
	cp build_cookcli.sh "$HOME"/bin/letters/update_instructions/cookcli
	add_cronjob_to_check_git_repository "$HOME"/bin/cookcli cookcli
fi
./build_cookcli.sh

# Add to PATH if not present
if grep -sq "^export PATH=.*cookcli.*" $HOME/.zshrc ; then
	: # Do nothing, already on the path
elif grep -sq "^export PATH=" $HOME/.zshrc ; then
	sed -i "s|^export PATH=|export PATH=$HOME/bin/cookcli/target/release:|" $HOME/.zshrc
else
	echo "export PATH=$HOME/bin/cookcli/target/release:\$PATH" >> $HOME/.zshrc
fi

if [ -d $HOME/.vim_runtime ] && [ ! -d $HOME/.vim_runtime/my_plugins/vim-cooklang ]; then
	git clone https://github.com/luizribeiro/vim-cooklang.git  $HOME/.vim_runtime/my_plugins/vim-cooklang
	add_cronjob_to_check_git_repository "$HOME/.vim_runtime/my_plugins/vim-cooklang" vim-cooklang
fi
