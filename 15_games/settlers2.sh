#!/bin/bash

if [ ! -d $HOME/games/settlers2 ]; then
    prevdir=$(pwd)

    # Checkout and build RTTR
    sudo pacman -S --needed git unzip jq cmake
    sudo pacman -S --needed sdl2 sdl2_mixer boost miniupnpc

    git clone --recursive https://github.com/Return-To-The-Roots/s25client.git $HOME/bin/s25client
    cd $HOME/bin/s25client || exit 1
    tagname=$(curl -sL \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/Return-To-The-Roots/s25client/releases" | \
      jq -r '[.[] | select(.prerelease == false)] | map(.tag_name) | first')
    git checkout $tagname
    git submodule update --init

    ## Fix build errors
    sed -i "s/#include </#include <cstdint>\n#include </" external/libsiedler2/src/oem.cpp
    sed -i "s/#include </#include <cstdint>\n#include </" libs/s25main/gameTypes/LanGameInfo.h
    curl https://raw.githubusercontent.com/Return-To-The-Roots/libutil/master/libs/network/src/UPnP_Other.cpp -o external/libutil/libs/network/src/UPnP_Other.cpp

    mkdir -p build && cd build || exit 1
    cmake -DRTTR_ENABLE_WERROR=off -DCMAKE_BUILD_TYPE=Release ..
    make

    mkdir -p $HOME/games/settlers2/share/s25rttr/S2
    mkdir -p $HOME/games/settlers2/bin
    cp bin/s25client bin/s25edit $HOME/games/settlers2/bin
    cp -r share libexec lib $HOME/games/settlers2

    # Place Settlers II game data into build
    cd "$prevdir" || exit 1
    echo ""
    echo "Enter password to unzip Settlers II"
    unzip s2g.zip -d $HOME/games/settlers2/share/s25rttr/S2

    # Copy config and system data
    mkdir -p $HOME/.s25rttr
    cp settlers2_config $HOME/.s25rttr/CONFIG.INI
    mkdir -p $HOME/.local/share/icons/hicolor/scalable/apps
    cp settlers2.svg $HOME/.local/share/icons/hicolor/scalable/apps
    sudo cp settlers2.desktop /usr/share/applications/s25client.desktop
fi
