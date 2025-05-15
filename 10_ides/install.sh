#!/bin/bash
source ../common/install.sh
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

product_code="$1"
product_dir="$2"
if ! ls "$HOME"/bin/"$product_dir"-* 1>/dev/null 2>&1 ; then
	install_programs curl tar
	curl -L "https://download.jetbrains.com/product?code=${product_code}&latest&distribution=linux" -o "$product_code".tar.gz

	mkdir -p "$HOME/bin"
	tar xvf "$product_code".tar.gz --directory="$HOME/bin"
	rm "$product_code".tar.gz

	jbconfdirname=$(grep -Po "^ *\"dataDirectoryName\": \"\K.+(?=\",)" "$HOME"/bin/"$product_dir"-*/product-info.json)
	jbdatadir="$confdir"/JetBrains/"$jbconfdirname"
	mkdir -p "$jbdatadir/options/linux"
	mkdir -p "$jbdatadir/keymaps"

	cp options_editor.xml       "$jbdatadir/options/editor.xml"
	cp options_editor-font.xml  "$jbdatadir/options/editor-font.xml"
	cp options_keymapFlags.xml  "$jbdatadir/options/keymapFlags.xml"
	cp options_ui-datetime.xml  "$jbdatadir/options/ui-datetime.xml"
	cp options_linux_keymap.xml "$jbdatadir/options/linux/keymap.xml"
	cp syzygy.xml "$jbdatadir/keymaps"

	# Create Desktop Entry
	prod="${product_dir,,}"
	sudo cp -s "$HOME"/bin/"$product_dir"-*/bin/"$prod".sh /usr/local/bin/"$prod"
	sudo cp jetbrains-"$prod".desktop /usr/share/applications

	# Put icons in their right place
	if [ "$(is_ubuntu)" -eq 1 ]; then
		icontype="png"
		iconsize="128x128"
	else
		icontype="svg"
		iconsize="scalable"
	fi
	mkdir -p "$datadir"/icons/hicolor/"$iconsize"/apps
	cp "$HOME"/bin/"$product_dir"-*/bin/"$prod"."$icontype" "$datadir"/icons/hicolor/"$iconsize"/apps/jetbrains-"$prod"."$icontype"
fi
