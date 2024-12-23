#!/bin/bash
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

prevdir=$(pwd)

if [ ! -d $HOME/bin/antimicrox ]; then
	mkdir -p "$confdir"/antimicrox
	cp gamepad.joystick.amgp antimicrox_settings.ini "$confdir"/antimicrox
	sed -i "s|\$HOME/.config|$confdir|g" "$confdir"/antimicrox/antimicrox_settings.ini

	git clone https://github.com/AntiMicroX/antimicrox.git $HOME/bin/antimicrox
	mkdir -p $HOME/bin/antimicrox/build
	cd $HOME/bin/antimicrox/build
	sudo pacman -S --needed gcc cmake extra-cmake-modules qt6-tools sdl2 itstool gettext
	cmake -DWITH_X11=OFF -DUSE_QT6_BY_DEFAULT=ON -DCMAKE_INSTALL_PREFIX=/usr ..
	cmake --build .
	sudo make install DESTDIR=/
	cd $prevdir
fi

if [ ! -d $HOME/games/zelda-a_link_to_the_past ]; then
	git clone https://github.com/snesrev/zelda3 $HOME/games/zelda-a_link_to_the_past/zelda3

	sudo pacman -S --needed unzip
	echo ""
	echo "Enter password to unzip the Zelda ROM"
	unzip zelda3.zip -d $HOME/games/zelda-a_link_to_the_past/zelda3

	# Copy desktop file and icon. This would be redundant if https://github.com/snesrev/zelda3/pull/248 or similar gets merged
	mkdir -p "$datadir"/icons/hicolor/scalable/apps
	cp zelda3.svg "$datadir"/icons/hicolor/scalable/apps
	sudo curl https://raw.githubusercontent.com/snesrev/zelda3/f5b19ef9dfdf9de6d07b2db8114c9862dcb48c26/platform/appimage/zelda3.desktop -o /usr/share/applications/zelda3.desktop
	sudo sed -iE "s|^Exec=.*|Exec=sh -c 'cd $HOME/games/zelda-a_link_to_the_past/zelda3; ./zelda3'|" /usr/share/applications/zelda3.desktop

	cd $HOME/games/zelda-a_link_to_the_past/zelda3
	#python3 -m ensurepip
	#python3 -m pip install -r requirements.txt
	sudo pacman -S --needed sdl2 python-pillow python-yaml
	make

	sed -i "s/^Autosave = 0/Autosave = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^Fullscreen = 0/Fullscreen = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^TurnWhileDashing = 0/TurnWhileDashing = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^SkipIntroOnKeypress = 0/SkipIntroOnKeypress = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^MiscBugFixes = 0/MiscBugFixes = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^GameChangingBugFixes = 0/GameChangingBugFixes = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^CancelBirdTravel = 0/CancelBirdTravel = 1/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^Controls = /#Controls = /" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^StopReplay = l/StopReplay = e/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
	sed -i "s/^# This default is suitable for QWERTY keyboards/# This default is suitable for the joypad\r\nControls = Up, Down, Left, Right, c, s, a, b, x, y, l, r\r\n\r\n# This default is suitable for QWERTY keyboards/" $HOME/games/zelda-a_link_to_the_past/zelda3/zelda3.ini
fi
cd $prevdir
