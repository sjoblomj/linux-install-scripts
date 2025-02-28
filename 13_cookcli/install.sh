#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env" # source cargo

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 22

if [ ! -d "$HOME"/bin/cookcli ]; then
	git clone https://github.com/cooklang/cookcli.git "$HOME"/bin/cookcli
fi

prevdir=$(pwd)
cd "$HOME"/bin/cookcli || exit 1
cargo build --release
cd ui || exit 1
npm install
npm run build
cd "$prevdir" || exit 1

# Add to PATH if not present
if grep -sq "^export PATH=.*cookcli.*" $HOME/.zshrc ; then
    : # Do nothing, already on the path
elif grep -sq "^export PATH=" $HOME/.zshrc ; then
    sed -i "s|^export PATH=|export PATH=$HOME/bin/cookcli/target/release:|" $HOME/.zshrc
else
    echo "export PATH=$HOME/bin/cookcli/target/release:\$PATH" >> $HOME/.zshrc
fi
