#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

product_code="$1"
product_dir="$2"
if [ ! -d $HOME/bin/${product_dir}-* ]; then
    sudo pacman -S --needed curl tar
    sudo pacman -S --needed xwayland  # No native Wayland support yet   https://youtrack.jetbrains.com/issue/JBR-3206
    curl -L "https://download.jetbrains.com/product?code=${product_code}&latest&distribution=linux" -o "${product_code}.tar.gz"

    mkdir -p $HOME/bin
    tar xvf "${product_code}.tar.gz" --directory=$HOME/bin
    rm "${product_code}.tar.gz"

    jbdatadir="$confdir"/JetBrains/$(grep -Po "\"jbdatadirectoryName\": \"\K.+(?=\",)" $HOME/bin/${product_dir}-*/product-info.json)
    mkdir -p "$jbdatadir/options/linux"
    mkdir -p "$jbdatadir/keymaps"

    cp options_editor.xml "$jbdatadir/options/editor.xml"
    cp options_editor-font.xml "$jbdatadir/options/editor-font.xml"
    cp options_keymapFlags.xml "$jbdatadir/options/keymapFlags.xml"
    cp options_ui-datetime.xml "$jbdatadir/options/ui-datetime.xml"
    cp options_linux_keymap.xml "$jbdatadir/options/linux/keymap.xml"
    cp syzygy.xml "$jbdatadir/keymaps"

    # Create Desktop Entry and icons
    prod="${product_dir,,}"
    sudo cp -s $HOME/bin/${product_dir}-*/bin/${prod}.sh /usr/local/bin/${prod}
    sudo cp jetbrains-${prod}.desktop /usr/share/applications
    mkdir -p "$datadir"/icons/hicolor/scalable/apps
    cp $HOME/bin/${product_dir}-*/bin/${prod}.svg "$datadir"/icons/hicolor/scalable/apps/jetbrains-${prod}.svg
fi
