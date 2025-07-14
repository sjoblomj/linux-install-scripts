#!/bin/bash
source ../common/cronjobs.sh
source ../common/github.sh
source ../common/menu.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$HOME"/bin
mkdir -p "$confdir"


# labwc
alt1="Yes, install Xwayland"
alt2="No, don't install Xwayland"
xwayland="-Dxwayland=disabled"
res=$(printf "%s\n%s" "$alt1" "$alt2" | select_menu "Install Xwayland?" '
Wayland is the replacement of the X Window System, but not all applications are Wayland ready.
Xwayland acts as a workaround, allowing X programs to continue to work under Wayland.
Xwayland is a complete X11 server, just like Xorg is, but instead of driving the displays and
opening input devices, it acts as a Wayland client.')
if [ "${res}" = "${alt1}" ]; then
	xwayland=""
	sudo pacman -S --needed xorg-xwayland
fi

sudo pacman -S --needed git jq
sudo pacman -S --needed wlroots wayland libinput libxkbcommon libxml2 cairo pango glib2 seatd
sudo pacman -S --needed meson ninja gcc wayland-protocols
sudo pacman -S --needed polkit

mkdir -p "$confdir"/labwc
cd "$HOME"/code/linux-install-scripts/00_config || exit 1
cp autostart environment menu.xml rc.xml themerc-override "$confdir"/labwc
cp .zprofile "$HOME"/
sed -i "s|\$HOME/.config|$confdir|g" "$confdir"/labwc/autostart
./download_icons.sh

mkdir -p "$HOME"/bin/letters/update_instructions
cp build_labwc.sh "$HOME"/bin/letters/update_instructions/labwc
add_cronjob_to_check_git_releases labwc "labwc/labwc" "$HOME"/bin/labwc "echo \$LABWC_VER"
labwc_path=$(download_latest_release_from_github "labwc/labwc" "$HOME/bin/labwc")
./build_labwc.sh "$labwc_path" "$xwayland"


# Internet Wireless Daemon
sudo pacman -S --needed iwd
sudo systemctl  enable  iwd
sudo systemctl  start   iwd


# Status bar
sudo pacman -S --needed waybar
mkdir -p "$confdir"/waybar
cp waybar_config "$confdir"/waybar/config
cp waybar_style.css "$confdir"/waybar/style.css


# Screen brightness control
sudo pacman -S --needed brightnessctl


# Volume settings
sudo pacman -S --needed curl
sudo pacman -S --needed pavucontrol
mkdir -p "$datadir"/icons/hicolor/scalable/apps
curl https://upload.wikimedia.org/wikipedia/commons/4/44/Gnome-multimedia-volume-control.svg -o "$datadir"/icons/hicolor/scalable/apps/multimedia-volume-control.svg


# Locale for calendar
./add_locales.sh


# Application launcher
sudo pacman -S --needed fuzzel
mkdir -p "$confdir"/fuzzel
cp fuzzel_config "$confdir"/fuzzel/fuzzel.ini


# Wallpaper
sudo pacman -S --needed swaybg
curl https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Expl0393_-_Flickr_-_NOAA_Photo_Library.jpg/800px-Expl0393_-_Flickr_-_NOAA_Photo_Library.jpg -o "$confdir"/background.jpg


# Extra fonts
sudo pacman -S --needed otf-font-awesome cantarell-fonts adobe-source-code-pro-fonts ttf-dejavu ttf-liberation noto-fonts ttf-fira-code


# Screenshot tools
sudo pacman -S --needed grim slurp swappy


# Notifications
sudo pacman -S --needed mako
mkdir -p "$confdir"/mako
cp mako_config "$confdir"/mako/config


# Screen locking
sudo pacman -S --needed swaylock swayidle
if [ ! -d "$HOME"/bin/chayang ]; then
	git clone https://git.sr.ht/\~emersion/chayang "$HOME"/bin/chayang
	mkdir -p "$HOME"/bin/letters/update_instructions
	cp build_chayang.sh "$HOME"/bin/letters/update_instructions/chayang
	add_cronjob_to_check_git_repository "$HOME"/bin/chayang
	./build_chayang.sh
fi
if [ ! -d "$HOME"/bin/wlopm ]; then
	git clone https://git.sr.ht/\~leon_plickat/wlopm "$HOME"/bin/wlopm
	mkdir -p "$HOME"/bin/letters/update_instructions
	cp build_wlopm.sh "$HOME"/bin/letters/update_instructions/wlopm
	add_cronjob_to_check_git_repository "$HOME"/bin/wlopm
	./build_wlopm.sh
fi


# Screen resolution
change=1
cmd=""
while [ $change -eq 1 ]; do
	alt1="Yes, change screen resolution"
	alt2="No, keep current screen resolution"
	res=$(printf "%s\n%s" "$alt1" "$alt2" | select_menu "Change screen resolution?")
	if [ "${res}" = "${alt1}" ]; then
		if [ ! -d "$HOME"/bin/wlr-randr ]; then
			sudo pacman -S --needed jq
			git clone https://gitlab.freedesktop.org/emersion/wlr-randr.git "$HOME"/bin/wlr-randr
			mkdir -p "$HOME"/bin/letters/update_instructions
			cp build_wlr-randr.sh "$HOME"/bin/letters/update_instructions/wlr-randr
			add_cronjob_to_check_git_repository "$HOME/bin/wlr-randr"
			./build_wlr-randr.sh
		fi
		echo ""
		read -rep "Enter screen scale factor: " factor
		cmd="\$HOME/bin/wlr-randr/build/wlr-randr --output \$(\$HOME/bin/wlr-randr/build/wlr-randr --json | jq '.[].name' --raw-output) --scale $factor"
		eval "$cmd"
	else
		change=0
	fi
done
if [[ -n "$cmd" ]]; then
	{
		echo ""
		echo "# Set scale factor after startup"
		echo "startuptime=\$(date +%s)"
		echo "while [[ \$((startuptime + 5)) -gt \$(date +%s) ]] && [[ -z \$LABWC_PID ]]; do sleep 0.1; done"
		echo "$cmd"
	} >> "$HOME"/.zprofile
fi


# Mouse speed
alt1="Yes, change mouse speed"
alt2="No, keep current mouse speed"
res=$(printf "%s\n%s" "$alt1" "$alt2" | select_menu "Change mouse speed?" '
Note that this will change the mouse speed for *all devices*.
For this setting to take effect, a re-login must be performed.')
if [ "${res}" = "${alt1}" ]; then
	if [ ! -d "$HOME"/bin/libinput-config ]; then
		git clone https://gitlab.com/warningnonpotablewater/libinput-config.git "$HOME"/bin/libinput-config
		mkdir -p "$HOME"/bin/letters/update_instructions
		cp build_libinput-config.sh "$HOME"/bin/letters/update_instructions/libinput-config
		add_cronjob_to_check_git_repository "$HOME"/bin/libinput-config
		./build_libinput-config.sh
	fi
	echo ""
	read -rep "Enter mouse speed factor: " factor
	echo "speed=$factor" | sudo tee /etc/libinput.conf
fi
