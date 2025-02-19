#!/bin/bash
source ../common/install.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ $(is_ubuntu) -eq 1 ] && [ ! -d "$HOME"/bin/yazi ]; then
	prevdir=$(pwd)
	mkdir -p "$HOME"/bin

	install_programs make gcc ffmpeg 7zip jq poppler-utils fd-find ripgrep zoxide imagemagick # fzf is also required but assumed to be installed already
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	. "$HOME/.cargo/env"
	rustup update

	git clone https://github.com/sxyazi/yazi.git "$HOME"/bin/yazi
	cd "$HOME"/bin/yazi
	cargo build --release --locked
	sudo cp target/release/yazi target/release/ya /usr/local/bin/

	cd "$prevdir" || exit 1
	./install_fonts.sh
else
	install_programs yazi
fi

if ! grep -sq "max_width" "$confdir"/yazi/yazi.toml ; then
	mkdir -p "$confdir"/yazi
	echo "
[manager]
show_hidden = true
show_symlink = true

[preview]
max_width = 4096
max_height = 4096
" >> "$confdir"/yazi/yazi.toml
fi
