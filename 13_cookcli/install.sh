#!/bin/bash
set -e
source ../common/cronjobs.sh
source ../common/path.sh

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

add_to_path_if_not_present "$HOME/bin/cookcli/target/release"

if [ -d "$HOME"/.vim_runtime ] && [ ! -d "$HOME"/.vim_runtime/my_plugins/vim-cooklang ]; then
	git clone https://github.com/luizribeiro/vim-cooklang.git "$HOME"/.vim_runtime/my_plugins/vim-cooklang
	add_cronjob_to_check_git_repository "$HOME"/.vim_runtime/my_plugins/vim-cooklang vim-cooklang
fi

currdir=$(pwd)
mkdir -p "$HOME"/.config/cook
ln -sf "$currdir"/aisle.conf "$HOME"/.config/cook/aisle.conf
