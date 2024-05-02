#!/bin/bash

mkdir -p $HOME/bin
prevdir=$(pwd)
cd $HOME/bin || exit 1
if [ ! -d ImHex ]; then
    git clone https://github.com/WerWolv/ImHex --recurse-submodules
    cd ImHex || exit 1

    sudo pacman -S --needed ccache
    sudo ./dist/get_deps_archlinux.sh

    mkdir -p build
    cd build || exit 1
    CC=gcc CXX=g++ cmake                          \
        -DCMAKE_BUILD_TYPE=Release                \
        -DCMAKE_INSTALL_PREFIX="/usr"             \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache        \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache      \
        -DCMAKE_C_FLAGS="-fuse-ld=lld"            \
        -DCMAKE_CXX_FLAGS="-fuse-ld=lld"          \
        -DCMAKE_OBJC_COMPILER_LAUNCHER=ccache     \
        -DCMAKE_OBJCXX_COMPILER_LAUNCHER=ccache   \
        -DIMHEX_USE_GTK_FILE_PICKER=ON            \
        ..
    sudo make -j 4 install

    mkdir -p $HOME/.local/share/icons/hicolor/scalable/apps/
    cp ../resources/icon.svg $HOME/.local/share/icons/hicolor/scalable/apps/imhex.svg
fi
cd "$prevdir" || exit 1
