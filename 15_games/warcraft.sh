#!/bin/zsh
set -e

sudo pacman -S --needed python python-pip cmake sdl2 sdl2_mixer sdl2_image lua51 tolua++ libtheora libvorbis libogg libmng libpng zlib lldb gdb
prevdir=$(pwd)
if [ ! -d $HOME/games/stratagus ]; then
	git clone https://github.com/Wargus/stratagus.git $HOME/games/stratagus
	cd $HOME/games/stratagus || exit 1
	cmake CMakeLists.txt
	cmake CMakeLists.txt -DLUA_INCLUDE_DIR=/usr/include/lua5.1
	make
fi

if [ ! -d $HOME/games/wargus ]; then
	git clone https://github.com/Wargus/wargus.git $HOME/games/wargus
	cd $HOME/games/wargus || exit 1
	cmake CMakeLists.txt -DSTRATAGUS=../stratagus -DSTRATAGUS_INCLUDE_DIR="../stratagus/gameheaders"
	make
fi

if [ ! -d $HOME/.local/share/stratagus/data.Wargus ]; then
	read -q "REPLY?Do you have your WarCraft II files ready to be extracted by Wargus? (y/n)"
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Just rerun this script when you want to extract the WarCraft data files"
		exit 0
	else
		cd $HOME/games/wargus
		./wargus
	fi
fi


# MIDI drivers are needed to play music, but it's unclear how to install those drivers on Arch Linux.
# Convert MIDI files to WAV manually; the game looks for WAVs as a fallback.
sudo pacman -S --needed timidity++ fluidsynth soundfont-fluid
if ! grep -sq "soundfont /usr/share/soundfonts/FluidR3_GM.sf2" /etc/timidity/timidity.cfg ; then
	sudo sed -i -r "s|^# soundfont (.*)|# soundfont \1\nsoundfont /usr/share/soundfonts/FluidR3_GM.sf2|" /etc/timidity/timidity.cfg
fi

if ! ls $HOME/.local/share/stratagus/data.Wargus/music/*.wav &> /dev/null ; then
	echo "Converting MIDI files to WAV"
	cd $HOME/.local/share/stratagus/data.Wargus/music || exit 1
	find . -name '*.mid' -exec timidity --output-mode=w --output-file={}.wav {} \;
	for file in *.mid.wav; do
		mv -- "$file" "${file%.mid.wav}.wav"
	done
fi

cd "$prevdir"
