#!/bin/bash
source ../common/github.sh
source ../common/cronjobs.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$HOME"/bin
mkdir -p "$confdir"


# labwc
alt1="Yes, install Xwayland"
alt2="No, don't install Xwayland"
xwayland="-Dxwayland=disabled"
res=$(printf "${alt1}\n${alt2}" | fzf --tac --margin=4 --border --border-label="Install Xwayland?"  --header='
Wayland is the replacement of the X Window System, but not all applications are Wayland ready.
Xwayland acts as a workaround, allowing X programs to continue to work under Wayland.
Xwayland is a complete X11 server, just like Xorg is, but instead of driving the displays and
opening input devices, it acts as a Wayland client. Notable programs that do not work without
Xwayland are GIMP 2.x and the Jetbrains IDEs (https://youtrack.jetbrains.com/issue/JBR-3206)')
if [ "${res}" = "${alt1}" ]; then
	xwayland=""
	sudo pacman -S --needed xorg-xwayland
fi

sudo pacman -S --needed git jq
sudo pacman -S --needed wlroots wayland libinput libxkbcommon libxml2 cairo pango glib2
sudo pacman -S --needed meson ninja gcc wayland-protocols
sudo pacman -S --needed polkit

labwc_path=$(download_latest_release_from_github "labwc/labwc" "$HOME/bin/labwc")

cd "$labwc_path" || exit 1
meson setup "${xwayland}" build/
meson compile -C build/
mkdir -p "$confdir"/labwc
cd "$HOME"/code/linux-install-scripts/00_config || exit 1
cp autostart environment menu.xml rc.xml themerc-override "$confdir"/labwc
cp .zprofile "$HOME"/
sed -i "s|./bin/labwc/build/labwc|${labwc_path// /\\\\ }/build/labwc|" "$HOME"/.zprofile
sed -i "s|\$HOME/.config|$confdir|g" "$confdir"/labwc/autostart


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
	cd "$HOME"/bin/chayang || exit 1
	add_cronjob_to_check_git_repository "$HOME"/bin/chayang
	meson setup build/
	ninja -C build/
	sudo cp build/chayang /usr/local/bin/
fi
if [ ! -d "$HOME"/bin/wlopm ]; then
	git clone https://git.sr.ht/\~leon_plickat/wlopm "$HOME"/bin/wlopm
	cd "$HOME"/bin/wlopm || exit 1
	add_cronjob_to_check_git_repository "$HOME"/bin/wlopm
	make
	sudo make install
fi


# Screen resolution
change=1
cmd=""
while [ $change -eq 1 ]; do
	alt1="Yes, change screen resolution"
	alt2="No, keep current screen resolution"
	res=$(printf "${alt1}\n${alt2}" | fzf --tac --margin=4 --border --border-label="Change screen resolution?")
	if [ "${res}" = "${alt1}" ]; then
		if [ ! -d "$HOME"/bin/wlr-randr ]; then
			sudo pacman -S --needed jq
			git clone https://git.sr.ht/\~emersion/wlr-randr "$HOME"/bin/wlr-randr
			cd "$HOME"/bin/wlr-randr || exit 1
			add_cronjob_to_check_git_repository "$HOME/bin/wlr-randr"
			meson setup build/
			ninja -C build/
		fi
		echo ""
		read -p "Enter screen scale factor: " factor
		cmd="\$HOME/bin/wlr-randr/build/wlr-randr --output \$(\$HOME/bin/wlr-randr/build/wlr-randr --json | jq '.[].name' --raw-output) --scale $factor"
		eval "$cmd"
	else
		change=0
	fi
done
if [[ -n "$cmd" ]]; then
	echo "" >> "$HOME"/.zprofile
	echo "# Set scale factor after startup" >> "$HOME"/.zprofile
	echo "startuptime=\$(date +%s)" >> "$HOME"/.zprofile
	echo "while [[ \$((startuptime + 5)) -gt \$(date +%s) ]] && [[ -z \$LABWC_PID ]]; do sleep 0.1; done" >> "$HOME"/.zprofile
	echo "$cmd" >> "$HOME"/.zprofile
fi


# Mouse speed
alt1="Yes, change mouse speed"
alt2="No, keep current mouse speed"
res=$(printf "${alt1}\n${alt2}" | fzf --tac --margin=4 --border --border-label="Change mouse speed?" --header='
Note that this will change the mouse speed for *all devices*.
For this setting to take effect, a re-login must be performed.')
if [ "${res}" = "${alt1}" ]; then
	if [ ! -d "$HOME"/bin/libinput-config ]; then
		git clone https://gitlab.com/warningnonpotablewater/libinput-config.git "$HOME"/bin/libinput-config
		cd "$HOME"/bin/libinput-config || exit 1
		add_cronjob_to_check_git_repository "$HOME"/bin/libinput-config
		meson setup build/
		cd build || exit 1
		ninja
		sudo ninja install
	fi
	echo ""
	read -p "Enter mouse speed factor: " factor
	echo "speed=$factor" | sudo tee /etc/libinput.conf
fi
