#!/bin/bash
set -e
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
sudo pacman -S --needed wlroots0.19 wayland libinput libxkbcommon libxml2 cairo pango glib2 libpng
sudo pacman -S --needed librsvg
sudo pacman -S --needed meson ninja gcc wayland-protocols
sudo pacman -S --needed polkit seatd

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


post_letter() {
	local feature="$1"
	local cmd="$2"
	local filename="$HOME/.letters/${feature// /_}"
	mkdir -p "$HOME"/.letters

	NO_FORMAT="\033[0m"
	F_BOLD="\033[1m"
	F_UNDERLINE="\033[4m"
	C_GREY46="\033[38;5;243m"
	C_WHITE="\033[38;5;15m"
	echo -e "${F_BOLD}${F_UNDERLINE}${C_WHITE}Change $feature${NO_FORMAT}" > "$filename"
	echo -e "${C_WHITE}Run the following command to change $feature:${NO_FORMAT}" >> "$filename"
	echo -e "${C_GREY46}$cmd${NO_FORMAT}" >> "$filename"
}


post_letter "screen resolution" "$HOME/code/linux-install-scripts/00_config/change_screen_resolution.sh"
post_letter "mouse speed"       "$HOME/code/linux-install-scripts/00_config/change_mouse_speed.sh"
